lists are polymorphic
tuples are polymorphic
a 0-tuple is refered to by `()` and is called "unit" - it's kind of like void.
with tuples, you are not applying functions with parenthises. you are applying
functions to tuples. so `fst (1,2)` is not invoking `fst` with two params.

Side effects are bad - and haskell tells us when a function will have them
by prefixing the type with `IO`. For instance, `readFile`:

    ghci> :type readFile
    readFile :: FilePath -> IO String

