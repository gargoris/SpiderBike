{-# LANGUAGE OverloadedStrings #-}
module Lib
  (
  someFunc,
  Suite,
  suiteParser
  ) where

-- import Control.Applicative ((<$>), (<*>), (<*), (*>), (<|>), many, (<$))
import Data.Char (isLetter, isDigit)
import Text.ParserCombinators.Parsec
import Text.Parsec
import Text.Parsec.String
import Control.Monad

someFunc :: IO ()
someFunc = putStrLn "someFunc"

-- |Full test suite
data Suite = Suite
             {
               id   :: Integer,
               name :: String
             } deriving (Show)
data Doc = Doc
           {
             title :: String,
             comments :: String
           }
  
-- |Full parser, returns a Suite if received a correct input
suiteParser :: Parser Suite
suiteParser = do
  _    <- lexeme (string "Suite")
  n    <- lexeme (num)
  name <- lexeme (ident)
  _    <- endOfLine
  return (Suite n name)

-- |Clean the whitespace... but no carriage returns
whitespace :: Parser ()
whitespace = void $ oneOf " \t"


-- |Left the whitespaces for hungries gnomes
lexeme :: Parser a -> Parser a
lexeme p = p <* optional whitespace


-- |A number
num :: Parser Integer
num = read <$> many1 digit

-- |A id with spaces...
ident :: Parser String
ident = (++) <$> many1 alphaNum <*> oneS

oneS :: Parser String
oneS = (++) <$> many (oneOf " \t") <*> many1 alphaNum
