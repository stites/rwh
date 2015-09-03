remember that singlequotes can be variable names, just like in math, you can
have an "x" and an "x-prime" - in haskell that translates into `x` and `x'`.

make sure all your functions are tail recursive! In an imperitive language,
it would be terrible if the compiler allocated memory for every recursive
_application_(?) functions would need linear - instead of constant - space.

Tail call optimization (tco) allows us to use constant space.

_THIS BOTHERS ME WTF IS HELPER?!?!?! Thoughts on where vs let!_
    -- file: ch04/Sum.hs
    mySum xs = helper 0 xs
        where helper acc (x:xs) = helper (acc + x) xs
              helper acc _      = acc

The class of functions that we can express using foldr is called _primitive
recursive_.

foldl in terms of foldr - this is just a _transformation of functors_.
foldl keeps laziness, foldr strictly evaluates?

_Thunks are more expensive to store than numbers_ -> makes sense.
when ghc evaluates a thunked expression it uses an _internal stack_ to do so.

thunks can be, potentially, infinitely large!_ - how does that work with things
like apache spark?_ so GHC will place a fixed limit on the maximun size of the
internal stack. so be careful of your thunking overhead - this "invisible
thunking" is called a space leak (code normal, but using way more space than
we expect). foldl' from `+Data.List` does not use thunks.

be careful of labelled lambdas - they will typecheck and will _fail at runtime_.

Sections: a kind of partial application where we indicate if it will be run from
the left or right. Looks like `(*3)` or `(3*)`. We can do the same with things
like `elem`: (`elem` ['a'..'z']) 'f', or all (`elem` ['a'..'z']) "Frobozz"

Functions for thought:
tails is tail, returning EVERY tail - tails always returns then empty list.

As-pattern: `xs@(_:xs')` - will take `xs` and bind it to `(_:xs')` -  helps to share data instead of copying it!
_where this be useful?_

use `head`s and `tail`s wisely - they can crash things

"So far in this chapter, we've come across two tempting looking features of Haskell: tail recursion and anonymous functions. As nice as these are, we don't often want to use them" _whaaaat_

a tail-recursive function has the same issue as a loop in an imperative language:
it's completely general. we _need_ to look at the entire definition of the function

Middle ground lies in the `fold`s - more obscure than `map/filter`, easier than
`Tail recursion`. ideally, just compose.
"naming the function is that it usually gets named something like 'f' or 'g' or 'helperFunc' and using a longer more descriptively named function instead of a lambda can make the function seem too important. " comment

More on space leaks:
foldl' (from Data.List) is _strict_ - we can also use `seq`

    foldl' _    zero []     = zero
    foldl' step zero (x:xs) =
        let new = step zero x
        in  new `seq` foldl' step new xs

this forces its argument to be evaluated in Weak Normal Form. `deepseq` (from
Monad.Control) evaluates to Normal Form.

to chain strict evaluation, use `seq` like so:

    chained x y z = x `seq` y `seq` someFunc z
    
This does not work:

    badExpression step zero (x:xs) =
        seq (step zero x) -- this is strictly evaluated
            (badExpression step (step zero x) xs) --this is not

because `step zero z` is duplicated in the body of the function so only the
first instance will be strictly evaluated. correct, bind with let:

    foldl' step zero (x:xs) =
        let new = step zero x
        in  new `seq` foldl' step new xs

for this:

   seq (1+2):(3+4):[]

seq will only evaluate (1+2), nothing else

   seq ((1+2),(3+4)) True 

will evaluate only the tuple - Weak Head Normal Form does not evaluate the inner
thunks

seq performs checks at runtime to see if an expression has been evaluated. Use
it sparingly. _so when is it good to be strict vs no? It sounds like it's better
for performance, but also... not_

> Aside from its performance cost if overused, seq is not a miracle cure-all
> for memory consumption problems. Just because you can evaluate something
> strictly doesn't mean you should. Careless use of seq may do nothing at all;
> move existing space leaks around; or introduce new leaks.

More on when to use `seq` in chapter 25

