`/=` instead of `!=`. It's supposed to resemble =/= in math.
`not` instead of `!=`.
operators have precidence, from 1(low) to 9(high). You can find out more by
checking `:info (+)` and noticing the `infixl 6 +` at the end. Stating that the
`+` operator has precidence 6, and that it is an `infix` operator with `left`
(so `infixl`) associativity. For more on this check out fixity rules.

(^) raises to the integre power, (\*\*) raises to the floating point power.

elements of a list have to be of the same type.

we can use enumeration like so:
 + [1..5] -- [1,2,3,4,5]
 + [1.0,1.25..2.0] -- [1.0,1.25,1.5,1.75,2.0]
 + [1,4..15] -- [1,4,7,10,13]
 + [10,9..1] -- [10,9,8,7,6,5,4,3,2,1]
 + [1..] -- goes on forever in ghci - never evaluated until called with ghc.
 + [1.0..1.8] -- [1.0,2.0] -- floating points are funky here.
   - to avoid floating point roundoff problems, the Haskell
   implementation enumerates from 1.0 to 1.8+0.5

++ concats
: unshifts and is right associative
strings are doublequoted
putStrLn prints a string with a newline at the end
characters are single-quoted
character arrays are interpreted by ghci as a string
`"" == []`
character arrays are synonymous to strings, so we can use `++` and `:`
operation
Haksell requiers typenames to start Uppercase'd and local variables to start
lowercase'd.
we can tell ghci to always print type information after an expression with 
`:set +t`
`x :: y` means "the expression x has the type y"
in ghci, `it` refers to the last successfully evaluated expression.
We can add modules to ghci with `:m` or `:module`
```
    ghci> :m +Data.Ratio
    ghci> 11 % 29
      11%29
      it :: Ratio Integer
```
`x :: y z` is read as "x is type y of z" (or `it` is type `Ratio` of `Integer`)"
we unset things that we've set in ghci with `:unset`
we can always get type information from something in ghci with `:type`



