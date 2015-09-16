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

[1]:http://chimera.labs.oreilly.com/books/1230000000929/index.html

