import Control.Concurrent

{- an example of _lock order inversion_ -}
nestedModification outer inner = do
  modifyMVar_ outer $ \x -> do
    yield  -- force this thread to temporarily yield the CPU
    modifyMVar_ inner $ \y -> return (y + 1)
    return (x + 1)
  putStrLn "done"

main = do
  a <- newMVar 1
  b <- newMVar 2
  forkIO $ nestedModification a b
  forkIO $ nestedModification b a
{- this should print nothing as a result of the deadlock -}


