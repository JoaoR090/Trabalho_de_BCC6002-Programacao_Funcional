module TextProcessor where

import Data.Char
import Data.List (sortOn)
import Data.Ord (Down(..))

contaPalavras :: String -> Int
contaPalavras texto = length (words texto)

contaPalavra :: [String] -> String -> Int
contaPalavra texto palavra = go texto palavra 0
    where
        go [] _ cont = cont
        go (x : rest) palavra cont
            | x == palavra = go rest palavra (cont + 1)
            | otherwise = go rest palavra cont

removeStopWords :: String -> String -> String
removeStopWords texto stopwords = go (words stopwords) (words texto)
    where
        go [] texto = unwords texto
        go (x : rest) texto = go rest (filter (/= x) texto)

contaPalavraVezes :: String -> [(String, Int)]
contaPalavraVezes texto = go (words texto) []
    where
        go [] lista = lista
        go (x : rest) lista
            | any (\(palavra, _) -> palavra == x) lista = go rest lista
            | otherwise = go rest (lista ++ [(x, contaPalavra (x : rest) x)])

ordenacaoFrequencia :: [(String, Int)] -> [(String, Int)]
ordenacaoFrequencia lista = sortOn (Down . snd) lista

ordenacaoLetra :: [(String, Int)] -> [(String, Int)]
ordenacaoLetra lista = sortOn fst lista

normalizacao :: String -> String
normalizacao texto = go texto
    where
        go [] = ""
        go (x : rest)
            | isPunctuation x = go rest
            | isNumber x = go rest
            | isUpper x = toLower x : go rest
            | isLower x = x : go rest
            | isSpace x = x : go rest
            | isControl x = go rest
            | otherwise = go rest

frequenciaRelativa :: [(String, Int)] -> Int -> [(String, Float)]
frequenciaRelativa _ 0 = []
frequenciaRelativa lista total = go lista []
    where
        go [] frequencia = reverse frequencia
        go (x : rest) frequencia = go rest ((fst x, fromIntegral (snd x) / fromIntegral total) : frequencia)
