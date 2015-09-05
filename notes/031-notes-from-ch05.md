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



