An algebraic data type can have more than one value constructor. This is also
sometimes called an "ADT," but this is often confused with "Abstract Data Type"
in other languages - so don't use that.

`Bool` is an algebraic data type: `data Bool = True | False`, with the `|`
describing the "or".

A type with more than one value constructor, refers to them as "alternatives,"
or "cases."

Tuples and algebraic data types overlap in use. Algebraic data types are useful
for differentiating data that is structurally identical. For example:

  ("a", "b")
  ("c", "d")

vs

  Cat "a" "b"
  Kitten "c" "d"

Note that the `(==)` operator requires arguments to be the same type.

In C/C++, you would use a structure:

    struct book_info {
      int id;
      char *name;
      char **authors;
    };

However in Haskell, the feild's ordering matters (they're "positional") - the
Haskell type is also anonymous.

In C/C++, you would use an enum:

    enum roygbiv {
      red, orange, yellow, green, blue, indigo, violet,
    };

Haskell gets the same thing with a 0-airy value constructor:

    data Roygbiv = Red | Orange | Yellow | Green | Blue | Indigo | Violet
                   deriving (Eq, Show)

But in C, enums are translated into integers, whereas in Haskell, they remain
as types. This is a problem, but not in haskell!

In C/C++, you would use a union:

    enum shape_type {
      shape_circle,
      shape_poly,
    };

    struct circle {
      struct vector centre;
      float radius;
    };

    struct poly {
      size_t num_vertices;
      struct vector *vertices;
    };

    struct shape {
      enum shape_type type;
      union {
        struct circle circle;
        struct poly poly;
      } shape;
    };

However this would require tracking the active alternative we are using. In the
example, the union can contain valid data for either a `struct circle` or a
`struct poly`. We have to use the `enum shape_type` by hand to indicate which
kind of value is currently stored in the union.

The Haskell variant is the same as what we have seen before:

    type Vector = (Double, Double)
    data Shape = Circle Vector Double
               | Poly [Vector]

