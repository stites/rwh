The Haskell environment looks like this:

Many interpreters. The GHC (Glasgow Haskell Compiler) is most commonplace it's
more suited to production environments and is very powerful. You should check
out more at [ghc's chapter in The Architecture of Open Source Applications][osa]
. Also, there is [hugs][hugs] which is no longer in development, but seems to
be used primarily for teaching.

The GHC has three main parts. The ghc compiler, the interactive interpreter
(ghci), and a runtime compiler to execute haskell code. Note that `ghc` can
compile down to `Cmm`, native, and llvm code - also that ghci is really useful
for debugging.


Pragmatics:
  - right now it looks like i'll be using ghc 7.10.2

[osa]:http://www.aosabook.org/en/ghc.html
[hugs]:https://www.haskell.org/hugs/

