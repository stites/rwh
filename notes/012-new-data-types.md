+ new data types are created with the 'data' keyword
+ Defining types improves the type safety, like how enums help type safety with
java vs strings in javascript.

    data BookInfo = Book Int String [String]
                    deriving (Show)

The `BookInfo` after the data keyword is the name of our new type.
We call BookInfo a type constructor.
type name and type constructor must start with a capital letter.

`Book` is the value constructor (data constructor) and is used to make values of
`BookInfo` type.

the `Integer`, `String`, and `[String]` that follow are the components of the
type. A component is the same as a field in a structure/class in another
language.

It's pretty normal to have the Type Constructor (`BookInfo`) be the same name as
the Value Constructor (`Book`).


