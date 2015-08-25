To make our own list, do the following:

    data List a = Cons a (List a)
                | Nil
                deriving (Show)

This forms a recursive algebraic datatype. Cons and Nil become value
constructors. Note that the value constructor, `Cons`, takes a `List` as another
component. So anything like `List`, `Cons 3` or `List 1` will fail. Now, to
construct a list, we must always start with the `Nil` constructor:

    Cons 2 Nil

or

    Cons 3 (Cons 2 Nil)

