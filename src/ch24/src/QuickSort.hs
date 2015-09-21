module Sorting where

import Control.Parallel (par, pseq)

sort :: (Ord a) => [a] -> [a]
sort (x:xs) = lesser ++ x:greater
    where lesser  = sort [y | y <- xs, y <  x]
          greater = sort [y | y <- xs, y >= x]
sort _ = []

parSort :: (Ord a) => [a] -> [a]
-- force evaluates the entire spine of a list before we give back a constructor
-- kind of like taking WHNF -> NF. or deepseq
parSort (x:xs)    = force greater `par` (force lesser `pseq`
                                         (lesser ++ x:greater))
    where lesser  = parSort [y | y <- xs, y <  x]
          greater = parSort [y | y <- xs, y >= x]
parSort _         = []


-- Instead of force lesser and force greater, here we evaluate lesser and greater:
sillySort (x:xs) = greater `par` (lesser `pseq`
                                  (lesser ++ x:greater))
    where lesser   = sillySort [y | y <- xs, y <  x]
          greater  = sillySort [y | y <- xs, y >= x]
sillySort _        = []
-- WHNF only computes enough of an expression to see its outermost constructor.
-- Since the outermost constructor in each case is just a single list constructor,
-- we are in fact only forcing the evaluation of the first element of each sorted
-- sublist!
-- Every other element of each list remains unevaluated.
-- In other words, we do almost no useful work in parallel: our sillySort is
-- nearly completely sequential.
