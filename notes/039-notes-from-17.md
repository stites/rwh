the haskell forgein function interface ("FFI") is how haskell interacts with
other languages in a clean way.

this kind of binding is a non-trivial task - you have to have some deep
knowledge of both languages

For Haskell, this technology stack is specified by the [Foreign Function
Interface addendum to the Haskell report][ffiad]. The FFI report describes how
to correctly bind Haskell and C together, and how to extend bindings to other
languages.

It gives us a performance escape hatch: if we can't get a code hot spot fast
enough, there's always the option of trying again in C.

(Note that fewer language extensions means more portable, reusable code.)

_maybe you should check out the javascript/typescript/es6/java/scala/closure 
bindings_

A common idiom when writing FFI bindings is to expose the C function with the
prefix "c\_"

When writing bindings you need to translate type signitures into haskell FFI
equivalets. Most people do this by prefixing the type with a reference to the
language (CDouble).

the haskell compiler _will_ generate incorrect code to call c since it doesnt
know anything about c! This can lead to warnings, or runtime craches.

Make sure you use the correct FFI types and use QuickCheck to test your C code
(via the bindings).

[ffiad]:https://www.haskell.org/onlinereport/haskell2010/haskellch8.html
