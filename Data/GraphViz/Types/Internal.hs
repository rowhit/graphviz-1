{- |
   Module      : Data.GraphViz.Types.Internal
   Description : Internal functions
   Copyright   : (c) Matthew Sackman, Ivan Lazar Miljenovic
   License     : 3-Clause BSD-style
   Maintainer  : Ivan.Miljenovic@gmail.com

   This module defines internal functions.
-}
module Data.GraphViz.Types.Internal where

import Data.Char( isAsciiUpper
                , isAsciiLower
                , isDigit
                )

isIDString        :: String -> Bool
isIDString []     = True
isIDString (f:os) = frstIDString f
                    && all restIDString os

-- | First character of a non-quoted 'String' must match this.
frstIDString   :: Char -> Bool
frstIDString c = any ($c) [ isAsciiUpper
                          , isAsciiLower
                          , (==) '_'
                          , \ x -> x >= '\200' && x <= '\377'
                          ]

-- | The rest of a non-quoted 'String' must match this.
restIDString   :: Char -> Bool
restIDString c = frstIDString c || isDigit c

-- | GraphViz requires double quotes to be explicitly escaped.
escapeQuotes           :: String -> String
escapeQuotes []        = []
escapeQuotes ('"':str) = '\\':'"': escapeQuotes str
escapeQuotes (c:str)   = c : escapeQuotes str

-- | Remove explicit escaping of double quotes.
descapeQuotes                :: String -> String
descapeQuotes []             = []
descapeQuotes ('\\':'"':str) = '"' : descapeQuotes str
descapeQuotes (c:str)        = c : descapeQuotes str