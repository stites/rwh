the monad typeclass captures chaining and injecting.
(>>=) is the chaining function and "returns" a value : called "bind"
(>>) is the chaining function but does not "return" a value : called ""
most monads have "fail" - be careful. they will throw "error" and crash your system
return is the identity function.
An "action" is another name for a monadic value.


