Maybe is great for handling errors - but be smart about it and be sure to let
your functions handle edge cases like infinite lists, etc.

Either is great, too - it allows us to carry attached data to success and
failure.

You can also create type aliases or data which specify what kind of error is
being thrown. Like so:

  data DivByError a = DivBy0 | ForbiddenDenominator a deriving (Eq, Read, Show)

Control.Monad.Error has some built-in support for Either String a

Exception handling in haskell is managed by functions (duh) like `try`. But
keep in mind that everything is lazy - doing something like:

  result <- try (return z)

will return undefined since return does not evaluate the expression.  ...but it
looks like ghci may be a little different these days. More on this later.
Anyhow, the recommended way of doing this is to execute:

  result <- try (evaluate x)

There is a function called handle (again in Control.Exception) which allows you
to handle failures gracefully.

There is also a function called `handleJust` which can one-up this by allowing
you to specify which errors you want to catch (note the `catchIt` function):

    import Control.Exception

    catchIt :: Exception -> Maybe ()
    catchIt (ArithException DivideByZero) = Just ()
    catchIt _ = Nothing

    handler :: () -> IO ()
    handler _ = putStrLn "Caught error: divide by zero"

    safePrint :: Integer -> IO ()
    safePrint x = handleJust catchIt handler (print x)

===================================

> System.IO.Error defines two functions: catch and try which, like their
> counterparts in Control.Exception, are used to deal with exceptions. Unlike
> the Control.Exception functions, however, these functions will only trap I/O
> errors, and will pass all other exceptions through uncaught. In Haskell, I/O
> errors all have type IOError, which is defined as the same as IOException.

_Import these in a qualified way so that you know which is which!_

> Data.Dynamic and Data.Typeable. We will not go into a great level of detail
> on those modules here, but will give you the tools you need to craft and use
> your own dynamic exception type.
