Parsing a file executable

This is the example exe file which will parse a string from the file
given on the command line. You can substitute your own parser for the
parser given below.

This part is important for accepting UTF-8 files (as it's stated somewhere in the official documentation!).
But the IO.UTF8 module was in an old utf8-string version, dropped by now, so... NO UTF8 in SpiderBike files.

import System.IO.UTF8
import Prelude hiding (readFile, writeFile)


> import System.Environment (getArgs)

> import Text.Parsec
> import Text.Parsec.String
> import Control.Monad

> main :: IO ()
> main = do
>     a <- getArgs
>     case a of
>       [str] -> parseFromFile suiteParser str >>= either print print
>       _ -> error "please pass one argument with the file containing the text to parse"

This is the parser which you can replace with your own code:

> data Suite = Suite {getName :: String}
> suiteParser :: Parser ()
> suiteParser = void $ string "Suite"

Here is an example of running this program:

$ echo x > source_text && runhaskell ParseFile.lhs source_text
"source_text" (line 1, column 1):
unexpected "x"
expecting "correct"
$ echo correct > source_text && runhaskell ParseFile.lhs source_text
()
