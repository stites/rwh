module Logger ( Logger , Log , runLogger , record) where

globToRegex :: String -> Logger String
globToRegex cs =
globToRegex' cs >>= \ds ->
return ('^':ds)

globToRegex' :: String -> Logger String
globToRegex' "" = return "$"
globToRegex' ('?':cs) =
record "any" >>
globToRegex' cs >>= \ds ->
return ('.':ds)

type Log = [String]

runLogger :: Logger a -> (a, Log)

record :: String -> Logger ()



