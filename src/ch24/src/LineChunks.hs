module LineChunks (chunkedReadWith) where

import Control.Exception (bracket, finally)
import Control.Monad (forM, liftM)
import Control.Parallel.Strategies (NFData, rnf)
import Data.Int (Int64)
import qualified Data.ByteString.Lazy.Char8 as LB
import GHC.Conc (numCapabilities)
import System.IO

data ChunkSpec = CS {
      chunkOffset :: !Int64
    , chunkLength :: !Int64
    } deriving (Eq, Show)

withChunks :: (NFData a) =>
              (FilePath -> IO [ChunkSpec])
           -> ([LB.ByteString] -> a)
           -> FilePath
           -> IO a
withChunks chunkFunc process path = do
  (chunks, handles) <- chunkedRead chunkFunc path
  let r = process chunks
  (rnf r `seq` return r) `finally` mapM_ hClose handles

chunkedReadWith :: (NFData a) =>
                   ([LB.ByteString] -> a) -> FilePath -> IO a
chunkedReadWith func path =
    withChunks (lineChunks (numCapabilities * 4)) func path

---------------------------------------
-- Lazy I/O poses a few well known hazards that we would like to avoid.

-- We may keep a file handle open for longer than necessary, by not forcing the computation that pulls data from it to be evaluated. Since an operating system will typically place a small, fixed limit on the number of files we can have open at once, if we do not address this risk, we can accidentally starve some other part of our program of file handles.
-- If we do not explicitly close a file handle, the garbage collector will automatically close it for us. It may take a long time to notice that it should close the file handle. This poses the same starvation risk as above.
-- We can avoid starvation by explicitly closing a file handle. If we do so too early, though, we can cause a lazy computation to fail if it expects to be able to pull more data from a closed file handle.

-- On top of these well-known risks, we cannot use a single file handle to supply data to multiple threads. A file handle has a single “seek pointer” that tracks the position from which it should be reading, but when we want to read multiple chunks, each needs to consume data from a different position in the file.
---------------------------------------

-- here we avoid starvation by explicitly closing file handles.
-- this allows multiple threads to read different chunks at
-- once by supplying each thread with a distinct file handle,
-- all reading the same file.
chunkedRead :: (FilePath -> IO [ChunkSpec])
            -> FilePath
            -> IO ([LB.ByteString], [Handle])
chunkedRead chunkFunc path = do
  chunks <- chunkFunc path
  liftM unzip . forM chunks $ \spec -> do
    h <- openFile path ReadMode
    hSeek h AbsoluteSeek (fromIntegral (chunkOffset spec))
    chunk <- LB.take (chunkLength spec) `liftM` LB.hGetContents h
    return (chunk, h)

-----------------------

lineChunks :: Int -> FilePath -> IO [ChunkSpec]
lineChunks numChunks path = do
  bracket (openFile path ReadMode) hClose $ \h -> do
    totalSize <- fromIntegral `liftM` hFileSize h
    let chunkSize = totalSize `div` fromIntegral numChunks
        findChunks offset = do
          let newOffset = offset + chunkSize
          hSeek h AbsoluteSeek (fromIntegral newOffset)
          let findNewline off = do
                eof <- hIsEOF h
                if eof
                  then return [CS offset (totalSize - offset)]
                  else do
                    bytes <- LB.hGet h 4096
                    case LB.elemIndex '\n' bytes of
                      Just n -> do
                        chunks@(c:_) <- findChunks (off + n + 1)
                        let coff = chunkOffset c
                        return (CS offset (coff - offset):chunks)
                      Nothing -> findNewline (off + LB.length bytes)
          findNewline newOffset
    findChunks 0
