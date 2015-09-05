module Main (main) where

import JSONLib
import PutJSON

main = putJValue (JObject [("foo", JNumber 1), ("bar", JBool False)])

