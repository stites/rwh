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
04. Monad transformers
05. MonadFix
06. Semigroup
07. Monoid
08. Foldable
09. Traversable
10. Category
11. Arrow
12. Comonad
