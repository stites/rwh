module NiceFork (
  ThreadManager, newManager, forkManaged, getStatus, waitFor, waitAll
  ) where

import Control.Concurrent
import Control.Exception (Exception, try)
import qualified Data.Map as M

data ThreadStatus = Running
   | Finished --terminated normally
   | Threw Exception -- killed by uncaught exception
     deriving (Eq, Show)

newtype ThreadManager =
  -- Mgr takes an MVar association list: this way we "modify" it with new versions
  -- this way any thread that tries to look at the map will have consistent view of
  -- it the association list mVar takes a thread Id and an MVar of that thread's
  -- status... This seems pretty hairy: what if you update the old list? non issue
  Mgr $ MVar $ M.Map ThreadId $ MVar ThreadStatus
  deriving (Eq)

{- make a new thread manager -}
newManager :: IO ThreadManager
newManager = Mgr `fmap` newMVar M.empty -- lift Mgr to IO because forkIO is used

{- create a mangaged thread -}
forkManaged :: IO ThreadManager -> IO () -> IO ThreadId
forkManaged (Mgr mgr) body =
  {- modifyMVar is a safe combination of `takeMVar` and `putMVar`
  -- if the function throws an exception the old value is put into the MVar
  -- with this, we avoid two common concurrency bugs:
  --   (1) forgetting to put a value back - resulting in a deadlock / infinite wait
  --   (2) failing to account for exceptions and assuming that putMVar succeeded
  -- Steps to reproduce this:
  --   (1) acquire a resource
  --   (2) pass the resoruces to a function that will do something with it
  --   (3) always release the resource even when an exception is thrown. Rethrow the
  --       exception.
  -}
  modifyMVar mgr $ \ m ->
    newEmptyMVar >>= state
    tid =<< forkIO $
      try body >>= result
      putMVar state (either Threw (const Finished) result)
    return (M.insert tid state m, tid)

{- Immediately return the status of a managed thread -}
getStatus :: ThreadManager -> ThreadId -> IO (Maybe ThreadStatus)
getStatus (Mgr mgr) tid =
  modifyMVar mgr $ \m ->
    case M.lookup tid m of
      -- if Nothing, immediately exit
      Nothing -> return (m, Nothing)
      Just st -> do
        mst <- tryTakeMVar st
        case mst of
          -- return that the thread is running
          Nothing -> return (m, Just Running)
          -- or indicate why the thread is teminated and stop managing the thread
          Just sth -> return (M.delete tid m, Just sth)

{- similar to getStatus but block until a specific managed
-- thread terminates before returning
-}
waitFor :: ThreadManager -> ThreadId -> IO (Maybe ThreadStatus)
waitFor (Mgr mgr) tid =
  maybeDone =<< modifyMVar mgr $ \ m ->
    -- Map's updateLookupWithKey: combines looking up a key with
    -- modifying/removing the value
    return $ case M.updateLookupWithKey (\_ _-> Nothing) tid m of
               -- we always want to remove the MVar holding the threads state:
               (Nothing, _) -> (m, Nothing)
               (done, m') -> (m', done)
  -- finally, we extract the value and return it
  case maybeDone of
    Nothing -> return Nothing
    Just st -> Just `fmap` takeMVar st

{- block until all managed threads terminate, ignore statuses -}
waitAll :: ThreadManager -> IO ()
waitAll (Mgr mgr) = modifyMVar mgr elems >>= mapM_ takeMVar
  where elems m = return (M.empty, M.elems m)

