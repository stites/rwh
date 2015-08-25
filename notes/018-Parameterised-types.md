Maybe is an example of a polymorphic, or generic, type. If we were to create our
own `Maybe`, we would find that it takes a parameter which is passed on into the
value creation of the type. Taking things one step further, we can create a
parameterized type by nesting one parameterized type inside of another one!

wrapped = Just (Just "wrapped")

Things start to get fuzzy, so we wrap things around in parenthesis to make sure
everything works smoothly.

