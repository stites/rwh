
lastButOne (x:_:[]) = Just x
lastButOne (_:xs) = lastButOne xs
lastButOne _ = Nothing
