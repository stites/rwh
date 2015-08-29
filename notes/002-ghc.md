GHC Notes
================

+ ghc initializes with `Prelude` - this is the standard library that is
included in your environment.
  - The Prelude module can be called 'the standard prelude'
  - (the?) prelude contents are defined by the Haskell 98 standard.
+ type `:?` in ghci for help.
    - to get this help manual from outside of `ghci`, use
      `echo ':?' | ghci | less`

on the ghci:
+ change the prompt of ghci with `:set prompt "ghci> "`
+ add modules to ghci with `:module + Data.Ratio`
+ currying is normal, so aside from _infix_ statements (like `2 + 2`), we can
  also execute prefix statements like `(+) 2 2`.

`-` is haskell's only unary operator, so we can't mix it with other infix
operators. So something like `2+ -3` is invalid.

Also! `-` is the only time when the usual space-intelligent compiler cannot be relied on. For instance, usually somthing like `function 3` will execute `function`
with variable `3`. However with a `-` unariy operation, it becomes unclear
whether we want to subtract `3` from `function` or if we want to initialize
`function` with `-3`. This becomes useful later.



