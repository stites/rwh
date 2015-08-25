If a value has more than one value constructor, then we need to know which
was used to make a value.

If a value has data components, we need to extract those components.

Haskell lets us define a _series of equations_ - the patterns are between the
equation name and the assignment operand. A successful pattern binds the
components to the named feilds.

Ordering of the equations is important! Matching goes from top to bottom,
stopping at the first success. Question of the day: does ghc form decision
branches for this? Is recursive pattern matching also tail recursive?

Pattern matching happens through _deconstruction_ of the constructor. This does
not break anything.

Tuple construction and deconstruction looks the same!

You should always exhaustively pattern match.

We can pattern match our own abstract data types with the value constructors:
`bookId (Book id title authors) = id`

We use the `_` as a wildcard to pattern match against things that may have
multiple interpretations, or things that we just don't care about since it will
not bind to anything. ie: `nicerID (Book id _ _ ) = id`

Point of emphasis: wild cards are great cause they eliminate extra variables.
If we use a wildcard, the compiler will be much happier.

GHC provides a compilation option, `-fwarn-incomplete-patterns`, that will cause
a warning during compilation if a sequence of patterns are not exhaustive. Use
it.

