{-# LANGUAGE OverloadedStrings #-}
module Lib
  (

    -- * Data Structures
    Suite,
    Doc,

    -- * Main function
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
               id     :: Integer
             , name   :: String
             , doc    :: Doc
             } deriving (Show)
data Doc = Doc 
           {
             title    :: String
           , comments :: String
           } deriving (Show)

-- |Full parser, returns a Suite if received a correct input
suiteParser :: Parser Suite
suiteParser = do
  _    <- whitespace
  _    <- lexeme (string "Suite")
  n    <- integer
  name <- ident
  _    <- endOfLine
  doc  <- parseDoc
  return (Suite n (rstrip name) doc)




-- |A id with spaces (multi-word). As a non desired effect, this returns all
-- all trailling spaces to EOL
ident :: Parser String
ident = (++) <$> many1 alphaNum <*> many (oneOf " \t" <|> alphaNum)

-- |Documentation, a title and a bunch of lines.
parseDoc :: Parser Doc
parseDoc = Doc <$> parseTitle <*> parseComs

-- |Parsing a title or a one line comment
parseTitle :: Parser String
parseTitle = whitespace *> (symbol "#") *> identifier <* optional endOfLine

-- |Parsing a line for a multine comment
parseComs' :: Parser String
parseComs' = whitespace *> (symbol "--") *> identifier <* endOfLine

parseComs :: Parser String
parseComs = concat <$> many1 parseComs'

-- From here, the utilities

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
identifier = (:) <$> firstChar <*> many nonFirstChar
  where
    firstChar = letter <|> char '_' <|> westEuropeLetter
    nonFirstChar = digit <|> firstChar <|> punctuationMark <|> oneOf " \t"

-- |Well, this is a parser mainly for european audiences...
westEuropeLetter :: Parser Char
westEuropeLetter = oneOf "áéíóúÁÉÍÓÚñÑçÇ"

-- |More letters
punctuationMark :: Parser Char
punctuationMark = oneOf ".¡!¿?.-_()/\"'&%$ºª"

-- |A parser for a String with a lexeme
symbol :: String -> Parser String
symbol s = lexeme $ string s

-- |A number
num :: Parser Integer
num = read <$> many1 digit

regularParse :: Parser a -> String -> Either ParseError a
regularParse p = parse p ""
