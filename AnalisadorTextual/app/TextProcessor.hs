module TextProcessor where

contaPalavras :: String -> Int
contaPalavras text = length (words text)

contaPalavra :: String -> String -> Int
contaPalavra text palavra = go (words text) palavra 0
    where
        go [] palavra cont = cont
        go (x : rest) palavra cont
            | x == palavra = go rest palavra (cont + 1)
            | otherwise = go rest palavra cont

removeStopWords :: String -> [String] -> String
removeStopWords