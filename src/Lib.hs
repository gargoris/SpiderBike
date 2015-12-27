{-# LANGUAGE OverloadedStrings #-}
module Lib
  (

    -- * Data Structures
    Suite,
    Doc,
    System,
    Module,

    -- * Main function
    suiteParser
  ) where

-- import Control.Applicative ((<$>), (<*>), (<*), (*>), (<|>), many, (<$))
import           Control.Monad
import           Data.Char                     (isDigit, isLetter)
import           Data.String.Utils
import           Text.Parsec
import           Text.Parsec.String
import           Text.ParserCombinators.Parsec

-- |Full test suite
data Suite  = Suite
              {
                suiteId    :: Integer
              , suiteName  :: String
              , doc        :: Doc
              , systems    :: [System]
              } deriving (Show)

data Doc    = Doc
              {
                title      :: String
              , comments   :: String
              } deriving (Show)

data System = System
              {
                systemId   :: Integer
              , systemName :: String
              , modules    :: [Module]
              } deriving (Show)

data Module = Module
              {
                moduleId   :: Integer
              , moduleTec  :: String
              , moduleName :: String
              , functions  :: [Function]
              } deriving(Show)

data Function = Function
                {
                  functionId :: Integer
                , functionDesc :: String
                } deriving (Show)

data TestCase = TestCase
                {
                  testCaseId :: Integer
                , testCaseDesc :: String
                , testCaseComment :: String
                , preCond :: [String]
                , steps :: [Steps]
                } deriving (Show)

data Steps = SimpleStep
                {
                  stepNumber :: Integer
                , stepComment :: String
                , sets :: [TwoFoldStep]
                }
              | ExecStep
                {
                  execContent :: String
                }
              | TestStep
                {
                  set :: TwoFoldStep
                }
              deriving (Show)

data TwoFoldStep = TwoFoldStepS String String
                 | TwoFoldStepI String Integer
                 deriving (Show)
  
                        
-- |Full parser, returns a Suite if received a correct input
suiteParser :: Parser Suite
suiteParser = do
  n    <- identifyCode "Suite"
  name <- ident
  _    <- endOfLine
  doc  <- parseDoc
  syst <- many systemParser
  return (Suite n (rstrip name) doc syst)

-- |Test Case
testCaseParser :: Parser TestCase
testCaseParser = TestCase
                 <$> identifyCode "C"
                 <*> (lexeme (string "=>") *> ident)
                 <*> parseTitle


-- |Function
functionParser :: Parser Function
functionParser = Function
                 <$> identifyCode "F"
                 <*> (lexeme (string "=>") *> ident)

-- |Module
moduleParser :: Parser Module
moduleParser = Module
               <$> identifyCode "M"
               <*> lexeme (char '(' *> ident <* char ')')
               <*> ((lexeme (string "=>")) *> ident)
               <*> many functionParser

-- |System, a parser...
systemParser :: Parser System
systemParser = System
               <$> identifyCode "SYST"
               <*> (lexeme (string "=>") *> ident)
               <*> many moduleParser

-- |Documentation, a title and a bunch of lines.
parseDoc :: Parser Doc
parseDoc = Doc
           <$> parseTitle
           <*> parseComs

-- |Parsing a title or a one line comment
parseTitle :: Parser String
parseTitle = whitespace
             *> (symbol "#")
             *> identifier
             <* optional endOfLine

-- |Parsing a line for a multine comment
parseComs' :: Parser String
parseComs' = whitespace
             *> (symbol "--")
             *> identifier
             <* endOfLine

parseComs :: Parser String
parseComs = concat
            <$> many1 parseComs'

-- From here, the utilities
-- |Starts with spaces, a keyword and a number....
identifyCode :: String -> Parser Integer
identifyCode t = whitespaceBeg
                 *> lexeme (string t)
                 *> integer

-- |A id with spaces (multi-word). As a non desired effect, this returns all
-- all trailling spaces to EOL
ident :: Parser String
ident = (++) <$> many1 alphaNum <*> many (oneOf " \t" <|> alphaNum)

-- |Clean the whitespace, beggining of line
whitespaceBeg :: Parser ()
whitespaceBeg = void $ many $ oneOf " \t\n"

-- |Clean the whitespace...
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
