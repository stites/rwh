
myFoldl :: (a -> b -> a) -> a -> [b] -> a
myFoldr :: (a -> b -> b) -> b -> [a] -> b

myFoldl f z xs = foldr step id xs z
    where step x g a = g (f a x)

myFoldr fun memo xs = foldl step id xs memo
    where step g x a = g (fun x a)
