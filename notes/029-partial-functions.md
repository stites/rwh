Functions which return values only for a subset of valid inputs are called
partial functions.

Note that error doesn't qualify as a returning value.

Functions that return valid results for their entire input domain are called
total functions.

This is really important to know and, apparently, haskell devs will go out of
their way to point this out in their code by prefixing partial functions with
`unsafe` so that it is explicit.

