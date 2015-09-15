import Control.Concurrent (MVar, putMVar, takeMVar)
import Control.Exception (block, catch, throw, unblock)
import Prelude hiding (catch) -- use the control catch instead

-- this should be simple enought for future modification.
modifyMVar :: MVar a -> (a -> IO (a, b)) -> IO b
modifyMVar m io =
  block $ do
    a <- takeMVar m
    (b, r) <- unblock (io a) `catch` $
                \e -> putMVar m a >> throw e
    putMVar m b
    return r

