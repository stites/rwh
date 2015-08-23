
lastButOne [] = Nothing
lastButOne (x:[]) = Just x
lastButOne (x:_:[]) = Just x
lastButOne (x:xs) = lastButOne xs
