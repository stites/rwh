import Control.Concurrent
import Control.Concurrent.Chan

{- for a one-time communication between threads, MVar is good
-- for a one-way communication between threads, Chan is good
-- if Chan is empty, readChan blocks until there is a value to read
-- writeChan never blocks, it write a new value to Chan immediately.
-}
chanExamples = do
  ch <- newChan
  forkIO $ do
    writeChan ch "hello world"
    writeChan ch "now I quit"
  readChan ch >>= print
  readChan ch >>= print
