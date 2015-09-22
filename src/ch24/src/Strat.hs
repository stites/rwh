
type Done = ()

type Strategy a = a -> Done

-- reduce to identity
-- The simplest strategy is named r0, and does nothing
r0 :: Strategy a
r0 _ = ()

-- reduce to weak head normal form:
-- Next one is a step up, it evaluates to WHNF
rwhnf :: Strategy a
rwhnf x = x `seq` ()

-- typeclass Normal Form Data with method named rnf
class NFData a where
  rnf :: Strategy a
  rnf = rwhnf

-- Char and Int NFData have identical WHNF and NF
instance NFData Char
instance NFData Int

instance NFData a => NFData (Maybe a) where
    rnf Nothing  = ()
    rnf (Just x) = rnf x

-- these can be found in Control.Parallel.Strategies
parList :: Strategy a -> Strategy [a]
parList strat []     = ()
parList strat (x:xs) = strat x `par` (parList strat xs)

parMap :: Strategy b -> (a -> b) -> [a] -> [b]
-- left of using : a normal application of map
-- right of using: an evaluation strategy
parMap strat f xs = map f xs `using` parList strat

-- The using combinator tells how to apply a strategy to a value
-- allows us to keep the code separate from evaluation strategy
using :: a -> Strategy a -> a
using x s = s x `seq` x

-- parZipWith applies zipWith in parallel, given a strategy
vectorSum' :: (NFData a, Num a) => [a] -> [a] -> [a]
vectorSum' = parZipWith rnf (+)

