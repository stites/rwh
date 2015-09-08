-- file: ch13/passwd-al.hs
import Data.List
import System.IO
import Debug.Trace
import Control.Monad(when)
import System.Exit
import System.Environment(getArgs)

main = do
    args <- getArgs
    when (length args /= 2) $ do
        putStrLn "Syntax: passwd-al filename uid"
        exitFailure
    content <- readFile $ head args
    let username = findByUID content (read ( args !! 1 ))
    case username of
         Just x -> putStrLn x
         Nothing -> putStrLn "Could not find that UID"

-- Given the entire input and a UID, see if we can find a username.
findByUID :: String -> Integer -> Maybe String
findByUID content uid =
    let al = map parseline . lines $ content
    in lookup uid al

-- make a log parser for the system errors below
logField :: [String] -> String
logField s = ("found field: " ++) $ concat s

-- Convert a colon-separated line into fields
parseline :: String -> (Integer, String)
parseline input =
    let fields = split ':' input
    in if length fields < 2
       then trace (logField fields) (1 , "test") :: (Integer, String)
       else (read (fields !! 2), head fields)

{- | Takes a delimiter and a list.  Break up the list based on the
-  delimiter. -}
split :: Eq a => a -> [a] -> [[a]]
split _ [] = [[]]
split delim str =
    let -- Find the part of the list before delim and put it in "before".
        -- The rest of the list, including the leading delim, goes
        -- in "remainder".
        (before, remainder) = span (/= delim) str
        in
        before : case remainder of
                      [] -> []
                      x -> -- If there is more data to process,
                           -- call split recursively to process it
                           split delim (tail x)
