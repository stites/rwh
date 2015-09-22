Seems like this chapter is an excellent lead-in to [Parallel and Concurrent
Programming in Haskell][1] by Simon Marlow, but is lower level and definitely worth
reading.

Some quick points: A concurrent program needs to perform several possibly unrelated
tasks at the same time, while a parallel one solves only a single problem.

> Another useful distinction between concurrent and parallel programs lies in their
> interaction with the outside world. By definition, a concurrent program deals
> continuously with networking protocols, databases, and the like. A typical parallel
> program is likely to be more focused: it streams data in, crunches it for a while
> (with little further I/O), then streams data back out.

most languages merge the two concepts since the primatives used are the same.

Concurrent programming with threads
------------------
most languages have threads. Haskell's look a little different, since it's considereds an `IO` action executing independently from other threads.

Question: _from other threads_ meaning "from the main thread"?

Threads are nondeterministic and there is no garunteed order in the way that they are
executed.

Threads are good for hiding latency and, you know, normal concurrent programming
stuff.

Funnily enough, the easiest and simlist way to share information between two threads
is to have them share a variable - this is okay since haskell only allows for
immutable data!

because of this, we need to have threads actively communicate with eachother: threads
have no idea if the other is still executing, has completed, or has crashed.

`MVar` is how we do this - it's a single-element box that can have things added to
it, or removed.

_seems like `handle` is broken, btw - find something to replace this!_

if we attempt to put something into `MVar` that is already full, or if we try to take
something out of an `MVar` that is empty, then the thread will be put to sleep until
a better situation arrives.

MVar is useful for two purposes (1) sending a message from one thread to another (via
a notification), also providing _mutual exclusion_ for a piece of mutable data that
is shared among threads.

GHC's runtime system treats the program's original thread of control differently from
other threads. When the original thread terminates, all other threads terminate _is
this safe?_

When we have long-running worker threads, we do a lot of work to ensure that the main
thread completes last.

Note: we can create a monadic function or action in pure code, then pass it around
until we end up in a monad where we can use it.

MVar and Chan are non-strict. It's not an issue, but people can forget this - maybe
because it's in IO - this can also cause problems with space/performance questions.

Chan always succeeds immediately so there is a potential risk in its use: If one
thread writes to a `Chan` more oftern than another reading thread, the `Chan` will
pile up will queue messages at an unreadable rate and we may get a memory leak.

Deadlock and Starvation
-----------------------------

One classic way to make a multithreaded program deadlock is to forget the order in
which we must acquire locks. This kind of bug is so common, it has a name: _lock
order inversion_.

Haskell has no locks! but MVar is prone to the order inversion problem.

The usual way to solve an order inversion problem is to always follow a consistent
order when acquiring resources. Since this requires manual adherence to a convention,
it's easy to miss in practice.

Deadlock sucks. Even in haskell. That's what I'm getting from this.

_Starvation_ is when a thread hogs a shared resource, preventing another thread from
using it. This can be caused or emphasized by MVar's non-strict nature.

Putting a thunk into an MVar makes it expensive to evaluate, and taking a thunk out
of an MVar should also be cheap, but evaluating the thunk might become crazy
compute-heavy and humble expectations.

Starvation sucks. Even in haskell.

BUT we have STMs to the rescue! More on this later.

=====================

GHC programs use one core, even when explicitly writing code concurrently.
We must explicitly indicate this at link time, with the `-threaded` flag, when we
make executablables

"unthreaded" runtimes written concurrently will run everythingn in one system thread
  - This runtime is highly efficient for creating threads and passing data
around via `MVar`s

"threaded" runtimes use multiple system threads and has more overhead for creating threads and using `MVar`s

you one pass `-N` to use all processors, and `-N4`, or similar to specify the number
of cores

anything with the commandline flag `+RTS`, up until `-RTS` will be evaluated in
the runtime system, not our program.

getArgs does not get any runtime options.

module `GHC.Conc` exports `numCapabilities` which tells us the number of cores the
runtime system has with the `-N` RTS option.

making programs threaded looks like this:

    $ ghc -c NumCapabilities.hs
    $ ghc -threaded -o NumCapabilities NumCapabilities.o
    $ ./NumCapabilities +RTS -N4 -RTS foo
    command line arguments: ["foo"]
    number of cores: 4

garbage collector used by GHC 6.8.3 is single threaded, but I think it is
multithreaded now.

the lower overhead of the non-threaded runtime may boost performance. so we
could be better off if we design our programs to run four simultanious copies,
non-threaded, than using four cores. Benchmark and see for yourself.

switching to the threaded runtime will not necessarily turn out as expected

Parallel programming
====================

`seq` evaluates an expression to head normal form (HNF). this is the same as
Weak-head normal form (WHNF) for normal data. For functions things are different,
find more on Stack overflow [here][so]. Unfortunately, the haskell wiki
disputes this as false. _So check in on this yourself_

`par` function is provided by `Control.Parallel`. It does the same as `seq` and
evaluates the left to WHNF, but does it in parallel with other evaluations.

seq: the compiler does WHNF only if it knows that evaluating the right argument
first would improve performance.

par: run rigth before left (WHNF...?) every time.

you need to know what to evaluate in parallel. Non-strict evaluation can get in the way of this, which is why we `force` in the parallel sort

par does not promise to evaluate an expression in parallel with another - it
does it if it "makes sense"... it's wishy washy, but is better than a garuntee and
gives the runtime system freedom to act intelligently.

runtime could decide that an expression is too cheap to be worth evaluating in
parallel or it could notice that all cores are currently busy, so "sparking" a
new parallel evaluation will lead to there being more runnable threads than
there are cores available to execute them _what happens in this case?_.

par is somewhat intelligent at runtime, so we can use it everywhere and assume
that performace will trend towards a maximum.

-----------------

Choosing a 'grain size' - the smallest unit of work parceled out to a core -
can be difficult.

  + If the grain size is too small, cores spend so much of their time on
    book-keeping and the program will be slower than serial counterpart.
  + If the grain size is too large, some cores may lie idle due to poor load
    balancing.

[so]: http://stackoverflow.com/questions/6872898/haskell-what-is-weak-head-normal-form
[1]:http://chimera.labs.oreilly.com/books/1230000000929/index.html

