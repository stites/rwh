Now it's time to go over the typeclassopedia!

see: https://wiki.haskell.org/Typeclassopedia
!(Picture of all of the types)[https://wiki.haskell.org/wikiupload/d/df/Typeclassopedia-diagram.png]

+ Solid arrows point from the general to the specific
+ Dotted arrows indicate some other sort of relationship.
+ Monad and ArrowApply are equivalent.
+ Semigroup, Apply and Comonad are greyed out since they are not actually (yet?) in the standard Haskell libraries.
  + Semigroup can be found in the semigroups package
  + Apply in the semigroupoids package
  + Comonad in the comonad package.

TOC:
  01. Functor
  02. Applicative
  03. Monad
  04. Monad transformers
  05. MonadFix
  06. Semigroup
  07. Monoid
  08. Foldable
  09. Traversable
  10. Category
  11. Arrow
  12. Comonad

01. Functor
the most basic type class. Functor represents a "container" of sorts, plus the
ability to apply a function uniformly to every element in the container.

    class Functor f where
      fmap :: (a -> b) -> f a -> f b

f is a type constructor (indicated by f a and f b). So f's kind is `* -> *`

instance Functor [] where
  fmap _ []     = []
  fmap g (x:xs) = g x : fmap g xs

instance Functor Maybe where
  fmap _ Nothing  = Nothing
  fmap g (Just a) = Just (g a)

`Either e` represents a container can contain a value of one of two types.
`((,) e)`  represents a container holds an "annotation" - think of it like
           `(e,)`-illegal- or `(1+)`

laws:

    fmap id = id
    fmap (g . h) = (fmap g) . (fmap h)

02. Applicative
applicative functors encapsulate a sort of "effectful" computation. A functor lets us
lift a function into a computational context - an applicative allows us to lift a
function which already has context, into said computational context. Note that every
Applicative is a Functor

    class Functor f => Applicative f where
      pure  :: a -> f a
      (<*>) :: f (a -> b) -> f a -> f b

Alternative definition:

    class Functor f => Monoidal f where
      unit :: f ()
      (**) :: f a -> f b -> f (a,b)
      -- aka --
      unit' :: () -> f ()
      (**') :: (f a, f b) -> f (a, b)

The alternative definition says that a monoidal functor is one which has some sort of
"default shape" and which supports some sort of "combining" operation.

Laws:

+ Identity Law: `pure id <*> v = v`

+ Homomomorphism: `pure f <*> pure v = pure (f x)` applying a non-effectful function to
a non-effectful argument in an effectful context, is the same as applying the
function to the argument and injecting it into context with pure.

+ Interchange: `u <*> pure y = pure ($ y) <*> u` when evaluating the application of an
effectful function to a pure argument, order of evaluation of function and argument
don't matter

+ Composition: `u <*> (v <*> w) = pure (.) <*> u <*> v <*> w` expressing associativity.
this is kind of tricky and unintuitive to make sense of, but you can feel the intent.

From a Monoidal standpoint:
+ Left identity: `unit ** v ≅ v`
+ Right identity: `u ** unit ≅ u`
+ Associativity: `u ** (v ** w) ≅ (u ** v) ** w`

03. Monad
Monad is a stricter subset of applicative, where you can shove values back into
context if they fall out.

    class Monad m where
      return ::   a -> m a
      (>>=)  :: m a -> (a -> m b) -> m b
      (>>)   :: m a ->        m b -> m b
      m >> n = m >>= \_ ->
      fail   :: String -> m a

Utility functions:
`Control.Monad` module utility functions, all of which can be implemented in terms of
the basic Monad operations - mostly return and (>>=)

`liftM :: Monad m => (a -> b) -> m a -> m b` fmap! just that Monad does not require
fmap
`ap :: Monad m => m (a -> b) -> m a -> m b` `<*>`! just that Monad is not an instance
of Applicative
`sequence :: Monad m => [m a] -> m [a]` takes a list of computations and combines
them into one computation which collects a list of their results. could be
Applicative-only
`replicateM :: Monad m => Int -> m a -> m [a]` is simply a combination of replicate and
sequence.
`when :: Monad m => Bool -> m () -> m ()` conditionally executes a computation,
evaluating to its second argument if the test is True, and to return () if the test
is False.
`mapM :: Monad m => (a -> m b) -> [a] -> m [b]` maps first argument over the second
and sequences the results
`forM` is just `mapM` with its arguments reversed.
`(=<<) :: Monad m => (a -> m b) -> m a -> m b is just (>>=)` with its arguments
reversed
`(>=>) :: Monad m => (a -> m b) -> (b -> m c) -> a -> m c` sort of like function
composition but with an extra `m` on the result type of each function. More later
`guard` function is used for instances of `MonadPlus` which is discussed in the
Monoid section.

underscored variants throw away the result of the computations.

also see filterM, zipWithM, foldM, and forever.

Laws:

    return a >>= k          = k a
    m        >>= return     = m
    m >>= (\x -> k x >>= h) = (m >>= k) >>= h

    fmap f xs  =  xs >>= return . f  =  liftM f xs

The first and second laws express the fact that return behaves nicely.

The third law essentially says that (>>=) is associative, sort of.

The last law ensures that fmap and liftM are the same for types which are instances
of both Functor and Monad—which, as already noted, should be every instance of Monad.

Alternatively:

    return >=> g      =  g
    g      >=> return =  g
    (g >=> h) >=> k   =  g >=> (h >=> k)

Note that (>=>) "composes" two functions of type `a -> m b` and `b -> m c`.

Do notation:

                      do e → e
           do { e; stmts } → e >> do { stmts }
      do { v <- e; stmts } → e >>= \v -> do { stmts }
    do { let decls; stmts} → let decls in do { stmts }

04. Monad transformers
Combine two monads, like `State` and `[]`? use monad transformers. It's not as clean
as combining Applicatives, but some monads can be combined in certain ways. All monad
transformers implement:

    class MonadTrans t where
      lift :: Monad m => m a -> t m a

In short, it allows computations in the base `m` monad to be lifted into computations
in the transformed monad `t m a`. So `t m a = (t m) a`. Lift must satisfy:

    lift . return  = return
    lift (m >>= f) = lift m >>= (lift . f)

which is basically just that lift transforms m a computations into t m a computations
resonably and sends the `return` and `(>>=)` of m to the same ones, but of `t m`

Libraries: `transformers` library provides standard monad transformers. Each monad
transformer adds a particular capability/feature/effect to any existing monad:

+ IdentityT: the identity transformer, which maps a monad to (something isomorphic
    to) itself. This may seem useless at first glance, but it is useful for the same
    reason that the id function is useful -- it can be passed as an argument to things
    which are parameterized over an arbitrary monad transformer, when you do not actually
    want any extra capabilities.
+ StateT: adds a read-write state.
+ ReaderT: adds a read-only environment.
+ WriterT: adds a write-only log.
+ RWST: conveniently combines ReaderT, WriterT, and StateT into one.
+ MaybeT: adds the possibility of failure.
+ ErrorT: adds the possibility of failure with an arbitrary type to represent errors.
+ ListT: adds non-determinism (however, see the discussion of ListT below).
+ ContT: adds continuation handling.

05. MonadFix
Monads which support the special fixpoint operation, `mfix`, which is supported in
GHC by a special "recursive do" notation.
    
    mfix :: (a -> m a) -> m a

in a `do` blokc, you may have a `rec` block: normally an embedded `do` block will not
be accessible by it's parent, but a `rec` block escapes this rule. It's like a `let`
block for actions.

06. Semigroup
https://wiki.haskell.org/Typeclassopedia#Semigroup

07. Monoid
08. Foldable
09. Traversable
10. Category
11. Arrow
12. Comonad
