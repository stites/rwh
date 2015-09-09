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

main = do act      --> main = act
main = do          --> main = act1 >> do act2 ..
  act1             --> //OR
  act2             --> main = act1 >>
  {- ...etc. -}    -->        act2 >>
  actN             -->        ...
