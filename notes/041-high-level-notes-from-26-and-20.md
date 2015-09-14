chapter 20: systems programming in haskell, seems a little m00t. Basically, it
discusses all the OS library bindints that we have access to, as well as some
points that we can actually run external programs in haskell, and that we have
some excellent pipes and streaming libraries. It seems a little dated, and
unimportant, so I'm going to kick this can down the road for the time being.

ah! but keep in mind that this is when we write perl in haskell - which is
pretty rad and something to keep in mind for the future.

Chapter 26: Advanced Library Design: building a bloom filter.
-----------

Going to skim over this one since I am itching to cut my teeth on some real
code, but this is another one of those chapters which is overly-long with an
excellent example and some great perls of wisdom.

here are the notes:

`UArray` contains unboxed values.

A type that can contain `bottom` is referred to as _lifted_. all normal haskell
types are lifted, which means that we can always write `error "eek!"` or
`undefined` instead of a normal expression. This abstraction, really of storing
thunks, comes at a performance hit. Anything _unboxed_ removes this abstraction
and evaluates thing in normal form.

Note that the counterpart of an unboxed type is a boxed one.

Modifying an immutable array is "prohibitively expensive."

_Question: is normal form the same as being unboxed? Does this mean that UArray
is copying the entire array everytime?_

The State Transformer (ST) Monad
---------------------------------

The ST Monad is just like the State Monad, but we can "thaw" an immutable array
to give us a mutable one, then "freeze" the array when we are done.

_seems a lot like a specific version of transients_

We can use "mutable references" to let us implement data structors that we can
modify after construction, just like in an imperative language. This is a must
for data structure and algorighms which have _no functional equivalent_.

The ST monad is designed so that we can enter this mutable state with `runST`,
then we can escape from it back to pure code later.

Note that in ST, we can't read or write files, create global variables, or
fork threads.

QuickCheck
---------------------
Requires properties to be monomorphic.

QuickCheck allows us to specify the range of valid values to generate, then it
uses the `forAll` combinator to make them by construction.

QuickCheck can also generate an arbitrary value for us and we can filter out
ones that don't fit our criteria using `(==>)`

Performance testing
---------------------
`rnf` seperates logic from evaluation. Check out more in performance and tuning

use profile-driven performance tuning- profile before and while you tune!


