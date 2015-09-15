import Control.Concurrent (forkIO)
import Control.Exception
import Control.Monad (forever)
import qualified Data.ByteString.Lazy as L
import System.Console.Readline (readline)

import Codec.Compression.GZip (compress)

main :: IO ()
main = do
    maybeLine <- readline "Enter a file to compress> "
    case maybeLine of
      Nothing -> return ()
      Just "" -> return () -- treat no name as "want to quit"
      Just name -> do
        --handle (\_-> putStrLn "failure") $ do
          content <- L.readFile name
          forkIO (compressFile name content)
          return ()
          main
        -- main
  where compressFile path = L.writeFile (path ++ ".gz") . compress

