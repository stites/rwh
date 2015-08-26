there's an `error` function with type: `error:: String -> a`. Weird, huh? You
give it a string and return an undisclosed type. This is so that `error` can
be placed in any function and the types will match. Error does not return a
value, but instead immediately aborts evaluation of code.

Major weakness of error: it doesn't let us distinguish between recoverable and
non-recoverable errors - everything thrown is non-recoverable.

So usually, it seems that people will use the `Maybe` type and return a
`Nothing` constructor. Although, RWH makes it seem like the norm is to let the
program fail as the normal way of doing thing. This seem absolutely wrong to me.
In the words of Rich Hickey from "[Are We There Yet?][hickey]": "you don't want
to drive a car with the guard rails."

[hickey]:http://www.infoq.com/presentations/Are-We-There-Yet-Rich-Hickey

