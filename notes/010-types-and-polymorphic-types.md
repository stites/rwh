Haskell doesn't have a return keyword
you can't assign a variable to a thing a second time
the `null` function below checks whether a list is empty
indentation means that you are continuing an existing definition
`xs` are everywhere. they mean 'plural of x'
Haskell is an expression-oriented language, not an imperitive one.
 - if an `if-else` expression only contains an `if`, then we do not have a full
   expression, and the compiler errors. This is because we don't give a type to
   the `else` branch.


Haskellism of the day:
> a bug becomes harder to fix exponentially over time.

[Quote from "Real World Haskell"][rwh]:
> Identifying a type variable
> Type variables always start with a lowercase letter. You can always tell a
> type variable from a normal variable by context, because the languages of
> types and functions are separate: type variables live in type signatures,
> and regular variables live in normal expressions.

> It's common Haskell practice to keep the names of type variables very short.
> One letter is overwhelmingly common; longer names show up infrequently. Type
> signatures are usually brief; we gain more in readability by keeping names
> short than we would by making them descriptive.

Also note that parameterised polymorphic types in Haskell are just like Java
generics or C++ templates. Most OO-languages preference subclassing, so they use
polymorphic subtypes - haskell isn't OO and doesn't do this. Coercion
polymorphism is also common, allowing a type to be implicitly converted into a
value of another type - haskell, again, doesn't permit this. See Walder's
paper, ["Theorems for free!"][walder] for more.

[rwh]:http://book.realworldhaskell.org/read/types-and-functions.html
[walder]: http://citeseer.ist.psu.edu/wadler89theorems.html
