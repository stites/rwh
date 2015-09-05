typeclasses are cool. they are the `class` and are _not_ declaring
OO-classes.

> Types are made instances of a particular typeclass by
> implementing the functions necessary for that typeclass.

Use ghc's typeclasses when possible

`Read` is the opposite of show. refer to src/ch06 for examples
the main point is that we need to give `read`s an explicit type

read and show are, supposidely, pretty efficient in serialization

read and show work pretty well with complex & polymorphic types

There are a lot of numeric types (Double, Float, Int[->64],
Integer, Rational, Word[->64]). _Word vs Int?_

Converting between numeric types is important! Usually, just use
to/from Rational, to/fromIntegral. also truncate if you are going
from rational to integral.

Automatic derivation is not always possible:
  `data MyType = MyType (Int -> Bool)`
can't work with show since you can't "show" a function

comments at the top of the file like: `{-# LANGUAGE x -}` are
called _pragma (still?)_ which enable a language extension.

_open world assumption_ - typeclasses are not confined to the
module where we define the typeclass: _SEEMS TERRIBLE_ and it is!
see the next section about overlapping instances. _Is the overlap
still true?_ it seems like haskell does FIFO.

Flexible/Overlapping Instances seems to be module/package-specific
and allows for ghc to do things like have a String foo fn work on
a Foo foo fn. ghc will still yell if it finds more than one
equally specific instance.

====================

we can use `data` or `newtype` to create types. `newtype` is for
renaming an existing type (?). `type`, on the other hand, just
refers to a type. IE - `type` is like the relationship between
[Char] and String, while `newtype` is a derivative to hide things.

Look at `newtype UniqueID = UniqueID Int deriving (Eq)`. Now Int
and UniqueId are different to the compiler and a user will never
see that a UniqueId comes from an Int. We have to show which of
the base class's typeclasses we want to use, or write our own and
not have to worry about writing our own and having them cause
issues.

also - `data` has overhead associated with it at runtime.
`newtype` does not. However! pattern matching with `undefined` is
different

when we export `newtype`, we don't export its `data (value?)
constructor`, in order to keep the type abstract. Instead we
export some "deconstructor" function, like the `convertModel`
from pfe2. this is so that a library author can change the under
lying bits later without having clients depend too much on it.

--------------------
load Control.Arrow into ghci and what is `second`
monomorphism restriction:

    ghci> :load Monomorphism
    [1 of 1] Compiling Main             ( Monomorphism.hs, interpreted )
    
    Monomorphism.hs:2:9:
        Ambiguous type variable `a' in the constraint:
          `Show a' arising from a use of `show' at Monomorphism.hs:2:9-12
        Possible cause: the monomorphism restriction applied to the following:
          myShow :: a -> String (bound at Monomorphism.hs:2:0)
        Probable fix: give these definition(s) an explicit type signature
                      or use -fno-monomorphism-restriction
    Failed, modules loaded: none.

_is this still around?_
