Seems like this chapter is an excellent lead-in to [Parallel and Concurrent
Programming in Haskell][1] by Simon Marlow, but is lower level and definitely
worth reading.

Some quick points: A concurrent program needs to perform several possibly
unrelated tasks at the same time, while a parallel one solves only a single
problem.

> Another useful distinction between concurrent and parallel programs lies in
> their interaction with the outside world. By definition, a concurrent program
> deals continuously with networking protocols, databases, and the like. A
> typical parallel program is likely to be more focused: it streams data in,
> crunches it for a while (with little further I/O), then streams data back
> out.

most languages merge the two concepts since the primatives used are the same.

Concurrent programming with threads
------------------
most languages have threads. Haskell's look a little different, since it's
considereds an `IO` action executing independently from other threads.

Question: _from other threads_ meaning "from the main thread"?

Threads are nondeterministic and there is no garunteed order in the way that
they are executed.

Threads are good for hiding latency and, you know, normal concurrent
programming stuff.

Funnily enough, the easiest and simlist way to share information between two threads is to have them share a variable - this is okay since haskell only allows for immutable data!

because of this, we need to have threads actively communicate with eachother: threads have no idea if the other is still executing, has completed, or has crashed.

`MVar` is how we do this - it's a single-element box that can have things added to it, or removed.

if we try to add

[1]:http://chimera.labs.oreilly.com/books/1230000000929/index.html
