module Lib
  (
  someFunc,
  Suite,
  suiteParser
  ) where

import Control.Applicative ((<$>), (<*>), (<*), (*>), (<|>), many, (<$))
import Data.Char (isLetter, isDigit)
import Text.ParserCombinators.Parsec
import Text.Parsec
import Text.Parsec.String
import Control.Monad

someFunc :: IO ()
someFunc = putStrLn "someFunc"

-- |Full test suite
data Suite = Suite {getName :: String} deriving (Show)

-- |Full parser, returns a Suite if received a correct input
suiteParser :: Parser Suite
suiteParser = Suite <$> string "Suite"


-- |A structural parser. It gets three parsers: one for starting,
-- other for ending, and a last one for the middle part. The idea
-- is to check if a block stars and ends with special delimiters
-- dropables and its inners honor some other parser
structP :: Parser a -> Parser b -> Parser c -> Parser c
structP start end t = start *> t <* end
