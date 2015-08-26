Use the keywords `let`..`in` to create a `let` block which will define all local
variables after the `let` in the scope preceeding the `in`. Note that the `let`
is bound to an expression, not a value - nothing is strictly typed unless
indicated. The scope created by the `let` block can be shadowed by nested `let`
blocks. You can also shadow function feilds.

Question: inspired by SML, how does haskell handle the different possible local
bindings: two local independent bindings (a simple `let`), two dependent
bindings (I assume via `let`), two mutually recursive functions (no idea)?

A `where` clause allows us to define local variables that preceed it. The idea
is that it offers readability, I assume because the business logic is at the top
of an expression, followed by the details. I believe that a more familiar
approach would be to put the `let` at the top of a function to define constants,
and place a `where` at the bottom with detailed functional bits.


