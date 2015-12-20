module Lib
  (
  someFunc
  ) where

import Text.ParserCombinators.Parsec
import Text.Parsec
import Text.Parsec.String
import Control.Monad

someFunc :: IO ()
someFunc = putStrLn "someFunc"

data Suite = Suite {getName :: String} deriving (Show)
suiteParser :: Parser ()
suiteParser = void (string "Suite")

s2 :: Parser String
s2 = string "Suite"
