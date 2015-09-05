class BasicEq a where
  isEqual :: a -> a -> Bool

data Color = Red | Green -- deriving (Show)

instance Show Color where
  show Red = "Red"
  show Green = "Green"

main = do
    putStrLn "Enter a Double:"
    inpStr <- getLine
    let inpDouble = read inpStr :: Double
    let inpDouble' = inpDouble * 2
    putStrLn ("Twice " ++ show inpDouble ++
              " is " ++ show inpDouble')

instance Read Color where
    readsPrec _ value = -- readsPrec is the main function for parsing input
        -- We pass tryParse a list of pairs. Each pair has a string and the
        -- desired return value. tryParse will try to match the input to one
        -- of these strings.
        tryParse [("Red", Red), ("Green", Green)]
        where tryParse [] = [] -- If there is nothing left to try, fail
              tryParse ((attempt, result):xs) =
                      -- Compare the start of the string to be parsed to the
                      -- text we are looking for.
                      if take (length attempt) value == attempt
                         -- If we have a match, return the result and the
                         -- remaining input
                         then [(result, drop (length attempt) value)]
                         -- If we don't have a match, try the next pair in the
                         -- list of attempts.
                         else tryParse xs
