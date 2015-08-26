A guard is introduced with a `|` character on an indented line (for a function
declaration). There can be zero or more guards and they work just like case
statements, except using conditionals instead of pattern matching. This means
that, once there is a successful guard evaluation, every expression is bound to
the various components declared.

Question: what is the difference in time/space complexity between guarding, case
statements, and pattern-matching?

Sometimes it is prudent to add a final guard to the effect of the expression:
`otherwise -> True`, so that the conditional is exhaustive. You can also use
a wildcard.

Note that you can use a guard anywhere you can use a pattern! This makes
patterns very flexible and allows us to take code like this:

    myDrop n xs = if n <=0 || null xs
                  then xs
                  else myDrop (n-1) $ tail xs

and convert it into nice patterns like the following:

    myDrop n xs | n <= 0 = xs
    myDrop _ []          = []
    myDrop n (x:xs)      = myDrop (n-1) xs

Very cool! RWH mentions that, "this change in style lets us enumerate up front
the cases in which we expect a function to behave differently. If we bury the
decisions inside a function as if expressions, the code becomes harder to read."
I think I would agree with them with the caveat that if-else statements are not
actually that hard to read - however this does seem like it would force us not
to blow our decision trees out of proportion.


