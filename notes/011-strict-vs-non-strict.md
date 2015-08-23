**Laziness** is not the same as **non-strictness**. Let's start with non-strictness.
The difference between strict and non-strictness, is that in a strict language,
the compiler evaluates all nested statements before invoking any functions.
In both non-strict and lazily evaluated functions, the compiler will not
evaluate these statements until it absolutely must - with one important
distinction between the two. Non-strictness has to do with mathmatical
semantics, and laziness has to do with operational behaviour (see [this so
answer for more][SO]). It is more intuitive, as a programmer, to think of
laziness first. Non-strictness, however, means that a mapping of bot will never
exist.

Note that the upside down "T", `_|_`, is referred to as "bot", or "Bottom", and
indicates some evaluation that fails. For more on non-strictness, check out the
[haskell wikibook on denotational semantics][wiki].

Haskell takes expressions and turns them into promises in the form of a _thunk_
which will not be evaluated until it is needed. The _laziness_ will make it such
that, if the expression is never used the thunk will never be evaluated and -
although I'm not 100% on this one - from what I have learned in the [Summer of
Haskell][soh] course - _non-strictness_ may allow the compiler to throw that
thunk out of the final codebase.

[SO]:http://stackoverflow.com/a/7141537/1529734
[wiki]: https://en.wikibooks.org/wiki/Haskell/Denotational_semantics
[soh]: https://youtu.be/iuBwKIcC198?t=1h16m14s
