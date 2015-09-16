{-# LANGUAGE BangPatterns #-}

import Control.Concurrent (MVar, putMVar, takeMVar)
import Control.Exception (block, catch, throw, unblock)
import Prelude hiding (catch) -- use Control.Exception's version


-- check lib: strict-concurrency for strict Chan and MVar
modifyMVar_strict :: MVar a -> (a -> IO a) -> IO ()
modifyMVar_strict m io = block $ do
    a  <- takeMVar m
    -- (!) pattern is simple to evaluate, but is not
    -- always sufficient to ensure data is evaluated
    !b <- unblock (io a) `catch` \e ->
          putMVar m a >> throw e
    putMVar m b

