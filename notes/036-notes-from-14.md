the monad typeclass captures chaining and injecting.
(>>=) is the chaining function and "returns" a value : called "bind"
(>>) is the chaining function but does not "return" a value : called ""
most monads have "fail" - be careful. they will throw "error" and crash your system
return is the identity function.
An "action" is another name for a monadic value.

we often use liftM in infix form. An easy way to read
such an expression is "apply the pure function on the
left to the result of the monadic action on the right"

(>>=) is lazy and doesn't promise when the arguments will be evaluated.

Control.Monad.Writer is great!

do-block sugar coats:

main1 = do act     --> main1 = act
main2 = do         --> main2 = act1 >>
  act1             -->         do act2
  act2             -->            {- ... etc. -}
  {- ...etc. -}    -->            actN
  actN             --> main2final = act1 >>
                   -->              act2 >>
                   -->              {- ... etc. -}
main3 = do         --> main3 =
  pattern <- act1  -->   let f pattern = do act2
  act2             -->                      {- ... etc. -}
  {- ... etc. -}   -->                      actN
  actN             -->       f _       = fail "..."
                   -->   in act1 >>= f

Note that with the `<-` translation, if the pattern match fails, the monad's
`fail` implementation gets run. Note that if you were to be working in the
context of the Maybe monad (instead of the IO monad), then `fail` just returns
`Nothing`.

main4 = do            --> main4 =
  let val1 = expr1    -->   let val1 = expr1
      val2 = expr2    -->       val2 = expr2
      {- ... etc. -}  -->       valN = exprN
      valN = exprN    -->
  act1                -->   in do act1
  act2                -->         act2
  {- ... etc. -}      -->         {- ... etc. -}
  actN                -->         actN

Note that you can't use the usual `in` with a do-block.

main5 = do                --> main5 =
  {                       -->
    act1;                 -->   act1 >>
    val1 <- act2;         -->   let f val1 = let val2 = expr1
    let { val2 = expr1 }; -->                in actN
    actN;                 -->       f _    = fail "..."
  }                       -->   in act2 >>= f

When you go "sugar free" its a reminder of what exactly is happening. Do this.

`(<<=)` is the flipped version of `(>>=)` and vice versa. Useful for situations
like so:

    wordCount = print . length . words =<< getContents

========================
The state monad can carry some kind of mutable state with it. The type is:
`s -> (a, s)`.

`runState` returns both the result and the final state
`evalState` returns only the result and throws away the final state
`execState` throws the result away and returns only the final state

==========================
functor laws:

  fmap id        ==   id 
  fmap (f . g)   ==   fmap f . fmap g

Monad laws:

(1) return is a left identity for (>>=):

  return x >>= f  === f x
  -- OR
  do y <- return x
     f y          ===  f x

Careful! that means that you don't need to return a pure value if you use it
with >>=. This mostly impacts code style.

(2) return is a right identity for (>>=):

  m >>= return     ===  m
  -- OR
  do y <- m
     return y      ===   m

Basically the same concequences as the last one.

(3) Monads are associative:
  m >>= (\x -> f x >>= g)   ===   (m >>= f) >>= g

Concequence: if we want to break a monad into smaller actions, then we don't
need to worry about how we break it up, so long as we maintain the ordering.

The first two laws show us how to avoid unnecessary use of return. The third
suggests that we can safely refactor a complicated action into several simpler
ones.

_BUT THE COMPILER WILL NOT ENFORCE THE MONAD LAWS_. We have to do that
ourselves!

