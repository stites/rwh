Monads have the `(<*>)` as well - it is called `ap`:

    ghci> :t ap
     ap :: Monad m => m (a -> b) -> m a -> m b
    ghci> :t (<*>)
     (<*>) :: Applicative f => f (a -> b) -> f a -> f b

Note that monads ARE applicatives now, in ghc 7.10 - so this actually isn't a
concern anymore.

`Control.Monad` module defines a typeclass, `MonadPlus`, that lets us abstract
the common pattern out of our case expressions.

    class Monad m => MonadPlus m where
       mzero :: m a
       mplus ::  m a -> m a -> m a

for lists and Maybes, we have the following:

    instance MonadPlus [] where
       mzero = []
       mplus = (++)

    instance MonadPlus Maybe where
       mzero               = Nothing
       Nothing `mplus` ys  = ys
       xs      `mplus` _   = xs

In essence, this is the same as mempty and mappend - except that the result
remains wrapped in a monoid.

mzero and mplus
------------------------------
an expression _must_ short circut if mzero is on the left of a right-bind.
    mzero >>= f == mzero
it must short circut if mzero is on the right of a sequenced expression.
    v >> mzero == mzero

_THESE ADDITIONS MAKE US FAIL SAFELY_ see the following:
lots of monoids impliment `fail` as `error` - with MonoidPlus, we can use mzero
to short circut evaluation as opposed to having fail blow up the program.

safe use of state monad:
----------------------------------
so, for instance, the random number generator from last time is pretty unsafe.
We leave the state monad in the hands of the end-user. Since the state monad is
mutable, this also means that an end user has full access to the state. bad news
bears. Lets learn how to tidy this up while maintaining a good ux.

_note that this is called a **leaky** implementation_ - "someone who uses it
knows that they're executing inside the State monad"

The idea is very simple: export only the constructors needed from the module,
and use a newtype to "wrap" (or "override") the existing state monad and hide
it from a user.

One requirement here is that we overwrite `State`s implimentation of `(>>=)`
and `return`, however this is boilerplate - so there is a language extension:
`{-# LANGUAGE GeneralizedNewtypeDeriving #-}` which does the brunt of this work
for you.

--------------------------------

Control.Arrow has two functions, `first` and `second` which will run a function
against the first or second value in a tuple.

----------------------------------

We can seperate out _interface_ from _implementation_ using several language
extensions. Take a look at the following typeclass which supplies unique
numbers:

    class (Monad m) => MonadSupply s m | m -> s where
        next :: m (Maybe s)

is uses the _Multi-parameter typeclasses_ extension. You can see that with the
following unfamiliar code: `MonadSupply s m`. Normally, typeclasses only take
one parameter, however this one takes two! this comes from the
`MultiParamTypeClasses` extension.

`| m -> s` is called a __functional dependency__, or __fundep__. it reads "such
that `m` uniquely determines `s`. With this, we can specify even more about the
relationship between : `FunctionalDependencies`.

The type checker is, essentially, a theorem prover, so this is helping in that.
Note that there are languages that are haskell with inherient proof-based
generation, but for haskell it's a little more rough around the edges and it
will only insist that the proof terminates. If we didn't do this, the compiler
would not be able to figure out the relationship.

`FlexibleInstances` will relax the compiler rules and allow us to use
`FunctionalDependencies` but apparently that's for some other day.

===================================

Note: it's perfectly legal to export something that was defined in another
module

Use newtype to hide anything mutable.

separation of interface and implementation is nice and clean, but when we start
combining monads in Monad transformers, it's really going to shine.

When we specify the monad like this, we sometimes need an escape hatch to do
something that we have not specified in the API. This exists in
`Control.Monad.Trans` where we define the MonadIO typeclass which has one
funciton, `liftIO` which lets us embed an IO action into another monad.

This is amazingly cool becaues it means we can mask IO from a monad and, thus,
use monads that CAN'T use IO at all!

check out :type tell for more on the writer monad



