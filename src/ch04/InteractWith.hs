-- this is our gateway file between "pure" and "impure" code
import System.Environment (getArgs)

interactWith :: (String -> String) -> FilePath -> FilePath -> IO ()
{-| ^
  'interactWith' is a simple and complete file processing program. it reads
  the contents of one file, applies 'function' to the file, and writes the
  result to another file.
-}

-- | the `do` keyword introduces a block of actions that can cause effects in
-- | the real world
interactWith function inputFile outputFile = do
    -- | the `<-` operator is equivalent to an assignment in a `do` block
    input <- readFile inputFile
    -- | note that `function` must be of type (String -> String)
    writeFile outputFile (function input)

main = mainWith myFunction
  where mainWith function = do
          args <- getArgs
          case args of
            [input,output] -> interactWith function input output
            _ -> putStrLn "error: exactly two arguments needed"

        -- replace "id" with the name of our function below
        myFunction = id

