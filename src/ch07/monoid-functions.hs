main::IO ()
main = ( return "line 1" >> return "line 2" ) >>= putStrLn
