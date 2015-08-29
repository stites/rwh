Haskellism of the day:
Let the types guide you, don't let them yell at you.

Thought of the day:
test should be guard rails. You wouldn't want to drive a car by crashing into
them.

Types! What are they? They're abstractions, cause machines will simply read 1's
and 0's. They allow us to say "these 1s and 0s are going to be doing x, these
will be doing y".

In haskell, the types are _strong_, _static_, and _inferred_.

Strong types garuntee that the program won't make certain errors and thus its
compiler will throw more errors than a weakly typed one. To be more specific,
strong vs. weak typing is really just checks against wether or not the following
exist:
 - type safety
 - memory safety
 - static type-checking
 - dynamic type-checking
Academia talks about the spectrum of strong to week typing with regard to how
permissive a type system is. The weaker the system, the more permissive it
allows certian expressions.

An interesting avenue of this is the difference of Type Conversion vs Type
Coercion. Conversion generates a brand-new object and is usually in strongly
typed systems. Coercion forces the usage of one type into that of another,
usually found in weakly typed systems.

In haskell, types are coerced - but only when explicitly told to do so. Another
interesting point is that haskell overloads literals. For instance, the number
`3` has type `Num` and, depending on the context, it will be evaluated as a
specialized type like `Int`, `Integer`, `Float`, `Double`, `Rational`, or more.

Haskell uses the Hindley-Milner (HM) method to infer types through a global
analysis. The HM method is a classical type system for a lambda calculus with
parametric polymorphism. Check out more from [wikipedia][hm].

[hm]:https://en.wikipedia.org/wiki/Hindley%E2%80%93Milner_type_system

