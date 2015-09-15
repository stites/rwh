import Control.Concurrent
import Control.Exception (Exception, try)
import qualified Data.Map as M

data ThreadStatus = Running
   | Finished --terminated normally
   | Threw Exception -- killed by uncaught exception
     deriving (Eq, Show)

newManager :: IO ThreadManager -- make a new thread manager
forkManager :: IO ThreadManager -> IO () -> IO ThreadId -- create a mangaged thread
-- Immediately return the status of a managed thread.
getStatus :: ThreadManager -> ThreadId -> IO (Maybe ThreadStatus)
-- block until a specific managed thread terminates
waitFor :: ThreadManager -> ThreadId -> IO (Maybe ThreadStatus)
-- block until all managed threads terminate
waitAll :: ThreadManager -> IO ()

