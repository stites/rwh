Anything that is type `IO _something_` is an I/O _action_.
`writeFoo = putStrLn "foo"` -> stored, nothing happens

IO can be glued together to make bigger IO

  ghci> let writefoo = putStrLn "foo"
  ghci> writefoo
  foo

notice: stout "foo" is a sideeffect
notice: we never invoke `writefoo`, but it was evaluated

-------------------

what is an IO Action?
 - Have the type `IO t`
 - Are first-class values in Haskell
 - fit seamlessly with Haskell's type system
 - Produce an effect when performed, but not when evaluated
   + IE- they only produce an effect when called in an I/O context
 - Any expression may produce an action as its value, but the action will not
   perform IO until it is executed inside another I/O action (or it is `main`)
 - Performing (executing) an action of type `IO t` may perform I/O and will
   ultimately deliver a result of type `t`

--------------------
Anything that is "IO" is actually a value that gets evaluated when "performed"
<- operator is used to "pull out" the result from an I/O action and store it
main is IO

is haskell imperative rather than pure, lazy, and functional when you add IO?
-------------------
`openFile` gives you a file `Handle`
`Handle` is used to perform specific operations on the file, like `hPutStrLn`
+ hPutStrLn - same as putStrLn, but goes into a file. _+1_
+ hClose to close Handles
basically "h" functions correspond to virtually all non-"h" functions for Handles

can we see Handlers operated on in real time? is it using sockets, buffer, fifo file?
http://www.gnu.org/software/libc/manual/html_node/FIFO-Special-Files.html

`return` is the opposite of `<-`: return takes a pure value and wraps it in IO

> Since every I/O action must return some IO type, if your result came from
> pure computation, you must use return to wrap it in IO.

SO it turns out that all the "h-<function>"s being aliases to the IO functions
is actually wrong and the truth is that it is the reverse! only that the un-h-d
functions are handles of STDIN and STDOUT

    getLine = hGetLine stdin
    putStrLn = hPutStrLn stdout
    print = hPrint stdout

if we are using stdin from the main method, we can use a linux pipe to declaree
input before we actually run the fucntion.

using stdin and stdout is great - just stick to unix-like programming

-----------------

deleting and renaming files can raise exceptions if the files don't exist - more
on this later.

use `openTempFile` or `openTempBinaryFile` for temp files - ie: mktemp

---------------

surprise! there is a second way to do IO in haskell! hGetContents has the type
`Handle -> IO String` and returns a string with all the contents. Usually this
is bad (you never know how big that file is going to be) but in haskell,
everything is lazy! Correction - usually handler menthods are not, but this one
is. As the string elements are read, the GC ditches those elements.

SHOW STOPPER - `hGetContents` can be passed to a PURE CONTEXT
LOOK BACK - if you use a value which has been created by `hGetContents` _more
than once_ you are forcing the compiler to keep the strings and this all falls
apart

> Just remember: memory is only freed after its last use.

--------------------

readFile and writeFile are shortcuts for openFile, hGetContents, hPutStr, hClose
but you never have to work with a handle

writing to a file is done lazily too, so no input is evaluated until it must be,
then the input is disposed of, as the memory is freed immediately.

`interact :: (String->String) -> IO ()` ie: takes a function of `String->String`
passes in the value of getContents, then sends the output to stdout

    runghc toUpper-lazy.hs < input.txt > output.txt

pipe input.txt into script, output to output.txt

a common, and powerful, use of `interact` is filtering. It's powerful especially
because of the laziness.

-----------------------

Haskell functions are not like other functions since they are _mathematical
function_. The tool for the outside world is called an _action_ - an action
resembles a function

`(>>)` - sequences two monads together like so: run monad a, run monad b, return
result of monad b.

`(>>=)` - runs an action on the left, then applies the result to the right
action and runs it.

    (return "hello" >> return "world!") >>= putStrLn

return is used to wrap pure values into IO ones

---------------------

haskell has no side effects, a monolouge: side effects are always possible, at a
certain level. a poorly written loop, even in a pure language, could overload
system RAM and cause everything to crash (a physical side effect). It could also
data to be swapped to disk (a side effect where raw machine code mutates). For
haskell, we can only claim that code will not trigger other commands that
trigger side effects. A pure function can't modify global variables, request IO,
or trigger a command to take down a system.

On the other side, this also means that pure functions do not have any
dependency on outside state.

One last comment from the peanut gallery was this:

> Non-IO functions are *meant* to have *no* side effects, although they can
> have side effects in certain circumstances (e.g. debugging). In contrast, IO
> functions are *meant* to have side effects i.e. they can be sequenced.

> The interesting observation is that one can implement sequencing in a pure
> functional way, through monads. Consequently, there is a natural distinction
> between monadic code (typically used for anything meant to have side effects)
> vs. non-monadic code (typically used for anything not meant to have side
> effects).

------------------

IO is the slowest part of compute. writing to disk vs writing to memory differs
by a magnitude of thousands or more. writing over network can be hundreds of
thousands more. Even if your IO operation doesn't write to disk, the IO requires
a system call. Busted.

OS usually helps with caching things. Languages usually help with buffering -
the act of making one large data request from the OS (even if we don't need it
all). This speeds up the program by having fewer requests. Haskell's default
buffer mode is not necessarily the fastest, so you may want to look into changin
this.

`BufferMode` types: `NoBuffering`, `LineBuffering`, and `BlockBuffering`.
`NoBuffering`: bad.
`LineBuffering`: only on newline characters or large output - the default.
`BlockBuffering`: takes fixed-size chunks "whenever possible" - this is great
for large datasets, but is impractical for human interaction. Takes a Maybe Int

flushing a buffer happens on `hClose` and `hFlush` (good for networking)

----------------------

`System.Environment.getArgs` returns `IO [String]` listing each argument.
`System.Environment.getProgName` returns `IO String` with the program name.

`System.Environment (getEnv, getEnvironment)` getEnv finds a specific variable
and will raise an exception. getEnvironment returns the whole environment in
`[(String, String)]` and you need to use things like `lookup` on it.

altering an environment is not cross-platform and only works from POSIX
platforms. See `System.Posix.Env`.




