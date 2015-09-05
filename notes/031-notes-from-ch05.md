you can add `:reload` to ghci to reload the last module
module must have the same name as the file itself _?_
must begin with a capital letter

syntax is `module` then `baseFileName` then `(exports..)` -  `(..)` means "all
of `JValue`'s value constructors - `where` lets us define the body of the module

_interesting_ - it may seem weird that we can export a type constructor
without its value constructor - _this is what allows us to make a type abstract_
 + _this is not abstract in an OO sense_ - this is more abstract in the ADT
   sense. I think he is talking about "inheritence" and "private fields"
 + this means that we hide implimentation details from users _?_
 + if we can't see the full type, we can't pattern match against it.

if we omit exports everything is exported. `module X where`
if we export Unit, then nothing is exported. `module X() where`

ghc expects a `Main` file. This can be configured accoring to the `main-is`
file

in haskell, much like with the V8 optimizing and non-optimizing compilers, you
want to seperate out points of uncertainty (io/try-catch) from the optimizable
code.

relying on type inference is a bad idea - adds degrees of freedom for the
compiler.

`undefined` and `error::[Char]->a` will both typecheck no matter where we use
it. 


