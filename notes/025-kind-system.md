check out the kind system - a type system for types! In ghci, you can input:

    ghci> :k Integer
    Integer :: *
    ghci> :k Maybe
    Maybe :: * -> *
    ghci> :k Either
    Either :: * -> * -> *
    ghci> :k (->)
    (->) :: * -> * -> *

`* -> *` describes a one-arity type, while `* -> * -> *` describes a two-arity
function. The kind system is simpler than the type system. As far as how to
describe the above, you would pronounce `*` as "type" and `->` as an "arrow
constructor".


