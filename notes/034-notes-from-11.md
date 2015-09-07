quickcheck - property-based testing. An improvement over HUnit.

_is there anything for BDD?_ _what about cucumber?_

`quickCheck` also has `verboseCheck` if you need details

using the (==>) implication function, we can add constraints to tests

test for these to start:
- idempotence: a $ a x == a x
- testing for properties: generic unit testing. can be pretty bdd
- test against a model
- data generation with `arbitrary`

HPC (Haskell Program Coverage) is an extension to ghc for code coverage!
we just have to add `-fhpc` ghc when compiling tests.
`hpc` is the cli to display statistics about what happened






