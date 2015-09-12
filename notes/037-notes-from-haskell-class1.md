ghci stuff to be aware of:
+ you can defer type error warnings until later with a language binding. This
  can be pretty useful.
+ `Interger` is _not_ double precision, it's infinit precision.
+ the kind system is unifiing with the type system
+ a ghci person is working on dependent types.
+ as always - Infinity is weird
+ fromIntegral makes types match, evaluates to the Num type.
+ functions have the HIGHEST precidence.
+ `:t otherwise :: Bool` otherwise is an alias for True
+ _let and where are allowed in a function - THEY ARE NEVER EVALUATED UNTIL
LATER!!!_
+ function type definitions are functions too!
+ type coercion/declaration is also a function!
+ _ask person about doubly linked lists!_

