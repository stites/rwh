we can use runtime flags for profiling: -sstderr

time profiling
---------------
-prof is used together with inlined with the SCC pragma:

    {-# SCC "mean" #-}

this adds a "cost center" to the function. alternatively, we can use -auto-all


in haskell, values with no arguments only need to be computed once, then shared with
later uses. If we want to now how expensive it is to compute them, use the "constant
applicative forms", or CAFs,with -caf-all

use -fforce-recomp to force full recompilation

the GHC runtime flag, -K, sets a larger stack limit for our program (like -K100M)

space profiling
---------------
