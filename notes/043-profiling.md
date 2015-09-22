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
GHC is able to generate graphs of memory usage of the heap, over a program's lifetime

This is perfect for revealing "space leaks", where memory is retained unnecessarily,
leading to the kind of heavy garbage collector activity we see in our example

Constructing a heap profile follows the same steps as constructing a normal time
profile, namely, compile with -prof -auto-all -caf-all, but when we execute the
program, we'll ask the runtime system to gather more detailed heap use statisticso

We can break down the heap use information in several ways: via cost-centre, via
module, by constructor, by data type, each with its own insights.

---------------------
Strict data types are another effective way to provide strictness information to the compiler. 

    -- a WHNF Pair
    data Pair a b = Pair !a !b

GHC compiles code down to Core, a "simple functional language"
Core is a subset of Haskell with unboxed data types (raw machine types, directly corresponding to primitive data types in languages like C)

Core has the final say, and if all-out performance is your goal, it is worth understanding

To view the Core version of our Haskell program we compile with the -ddump-simpl flag, or use the ghc-core tool

D# is a heap-allocated Double value - if returned, it will
lift the raw double value onto the heap. We can dodge this
with -funbox-strict-fields and the following code change:

    data Pair = Pair !Int !Double
-----------------------
general rules for profiling and optimization:
+ Compile to native code, with optimizations on
+ When in doubt, use runtime statistics, and time profiling
+ If allocation problems are suspected, use heap profiling
+ A careful mixture of strict and lazy evaluation can yield the best results
+ Prefer strict fields for atomic data types (Int, Double and similar types)
+ Use data types closer to the native machine representation (prefer Int over Integer)

-----------------------
Advanced techniques: fusion

GHC is able to transform the list program into a listless version, using an
optimization known as deforestation, which refers to a general class of
optimizations that involve eliminating intermediate data structures

stream fusion: transforms recursive list generation and transformation functions into
non-recursive `unfolds`

----------------------
Tuning the generated assembly

To view the generated assembly, we can use a tool like ghc-core, or generate
assembly to standard output with the -ddump-asm flag to GHC.

 We have few levers available to adjust the generated assembly, but we may choose
 between the C and native code backends to GHC, and, if we choose the C backend,
 which optimization flags to pass to GCC

Particularly with floating point code, it is sometimes useful to compile via C, and
enable specific high performance C compiler optimizations.

we can squeeze out the last drops of performance from our final fused loop code by
using -funbox-strict-fields -fvia-C -optc-O2, which cuts the running time in half
again (as the C compiler is able to optimize away some redundant move instructions in
the program's inner loop)

