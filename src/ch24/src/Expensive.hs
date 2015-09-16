import Control.Concurrent


thisIsNotQuiteRight = do
  -- make a new MVar
  mv <- newEmptyMVar
  -- split off the expensive computation
  -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  -- Never runs until this is evaluated
  -- FIX: strictly evaluate this instead
  forkIO $ expensiveComputation_stricter mv
  -- do something else
  someOtherActivity
  -- take MVar and place in result
  -- never finishes: MVar empty so this never finishes
  result <- takeMVar mv
  -- return result
  print result

expensiveComputation mv = do
  let a = "this is "
      b = "not really "
      c = "all that expensive "
  putMVar mv (a ++ b ++ c)


