data structures! this should be exciting!
indexed, unordered data:
  two common ways of doing this- `Map`, and association lists.

association lists, basic way of looking up values is with the `lookup` function

wow! `trace` is really useful for debugging pure functions

`Data.Map` provides `Map` - just like an association list, but more performant

Functions are data, too - we can pass them around like values.
- this is part of the "functions as first class citizens"

_How do we close off a closure in haskell?_
-------------------------

> Reverse Polish Notation (RPN)? RPN is a postfix notation that never requires
> parentheses, and is commonly found on HP calculators. RPN is a stack-based
> notation. We push numbers onto the stack, and when we enter operations, they
> pop the most recent numbers off the stack and place the result on the stack

------------------------
the expression `"a" ++ "b" ++ "c"` is pretty bad. Why? because it's `infixr`,
so this will be quadratic in space_?_ complexity. `"a" ++ ("b" ++ "c")` is more
performant (linear space).

We can make it just as performant if we do something like: 
`("a" ++) . ("b" ++) $ "c"` since we are storing partial applications of
appends, not running the actual appends itself. So one thing which we might
benefit from is that we can have a _difference list_, by cerating a new datatype
that has the difference, and the function that will be applied. More next:

...and that was the introduction of Monoids!

However RWH mentions that DList and list are both not as performant as something
like `Data.Sequence`. Seems like Sequence and List are almost identical. We use
List normally because of overhead and becaues List is usually enough for the job



