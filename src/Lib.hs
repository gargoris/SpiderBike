module Lib
  (
  someFunc,
  Suite,
  suiteParser
  ) where

import Text.Parsec.String (Parser)
import Text.Parsec.String.Char (oneOf, char, digit, letter, satisfy)
import Text.Parsec.String.Combinator (many1, chainl1)
import Control.Applicative ((<$>), (<*>), (<*), (*>), (<|>), many, (<$))
import Control.Monad (void, ap)
import Data.Char (isLetter, isDigit)import Text.ParserCombinators.Parsec
import Text.Parsec
import Text.Parsec.String
import Control.Monad

someFunc :: IO ()
someFunc = putStrLn "someFunc"

data Suite = Suite {getName :: String} deriving (Show)
suiteParser :: Parser String
suiteParser = string "Suite"

s2 :: Parser String
s2 = string "Suite"
