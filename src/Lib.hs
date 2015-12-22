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
import Data.String.Utils

someFunc :: IO ()
someFunc = putStrLn "someFunc"

-- |Full test suite
data Suite = Suite
             {
               id   :: Integer
               , name :: String
               , doc  :: Doc
             } deriving (Show)
data Doc = Doc String deriving (Show) --String
--           {
--             title :: String,
--             comments :: String
--           }

-- |Full parser, returns a Suite if received a correct input
suiteParser :: Parser Suite
suiteParser = do
  _    <- lexeme (string "Suite")
  n    <- integer
  name <- ident
  _    <- endOfLine
  doc  <- parseDoc
  return (Suite n (rstrip name) doc)


-- |Clean the whitespace... but no carriage returns
whitespace :: Parser ()
whitespace = void $ many $ oneOf " \t"

-- |Left the whitespaces for hungries gnomes
lexeme :: Parser a -> Parser a
lexeme p = p <* whitespace

-- |Reading an number, an integer
integer :: Parser Integer
integer = read <$> lexeme (many1 digit)

-- |An identifier
identifier :: Parser String
identifier = lexeme ((:) <$> firstChar <*> many nonFirstChar)
  where
    firstChar = letter <|> char '_'
    nonFirstChar = digit <|> firstChar

symbol :: String -> Parser String
symbol s = lexeme $ string s


-- |A number
num :: Parser Integer
num = read <$> many1 digit

-- |A id with spaces (multi-word). As a non desired effect, this returns all
-- all trailling spaces to EOL
ident :: Parser String
ident = (++) <$> many1 alphaNum <*> many (oneOf " \t" <|> alphaNum)

-- |Documentation, a title and a bunch of lines.
parseDoc :: Parser Doc
parseDoc = Doc <$> parseTitle

-- |Parsing a title or a one line comment
parseTitle :: Parser String
parseTitle = do
  _ <- whitespace
  _ <- lexeme (char '#')
  n <- ident
  return n

-- |Parsing a multi line comment
--parseComs :: Parser String
--parseComs = whitespace *> char "-" *> char "-" 
