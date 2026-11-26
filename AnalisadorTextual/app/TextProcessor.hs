module TextProcessor where

import qualified Data.Map as Map
import Data.Char

contaPalavras :: String -> Int
contaPalavras text = length (words text)

contaPalavra :: [String] -> String -> Int
contaPalavra text palavra = go text palavra 0
    where
        go [] palavra cont = cont
        go (x : rest) palavra cont
            | x == palavra = go rest palavra (cont + 1)
            | otherwise = go rest palavra cont

removeStopWords :: String -> String -> String
removeStopWords texto stopwords = go (words stopwords) (words texto)
    where
        go [] texto = unwords texto
        go (x : rest) texto = go rest (filter (/= x) texto)

contaPalavraVezes :: String -> Map.Map String Int
contaPalavraVezes texto = go (words texto) Map.empty
    where
        go [] mapa = mapa
        go (x : rest) mapa | Map.lookup x mapa /= Nothing = go rest mapa | otherwise = go rest (Map.insert x ((contaPalavra rest x) + 1) mapa)

normalizacao :: String -> String
normalizacao text = go text
    where 
        go [] = ""
        go (x : rest) 
            | isPunctuation x = go rest 
            | isNumber x = go rest 
            | isUpper x = [toLower x] ++ go rest 
            | isLower x = [x] ++ go rest 
            | isSpace x = [x] ++ go rest 
            | isControl x = go rest
            | otherwise = go rest