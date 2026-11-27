import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO (hPutStrLn, stderr)
import TextProcessor

data SourceType = File | Text
    deriving (Enum, Show, Eq)

data Options = Options {
    stopwords  :: Bool,
    sortAlf     :: Bool,
    freqRel    :: Bool,
    sourceType :: SourceType,
    source     :: String
} deriving (Show)

defaultOptions :: Options
defaultOptions = Options
    { stopwords  = False
    , sortAlf     = False
    , freqRel    = False
    , sourceType = Text
    , source     = ""
    }

parseArgs :: [String] -> Either String Options
parseArgs = go defaultOptions
    where
        go opts []
            | null (source opts) = Left "falta a fonte: use --file <caminho> ou --text <texto>"
            | otherwise = Right opts
        go opts ("--stopwords" : rest) = go opts { stopwords = True } rest
        go opts ("--sortAlf" : rest) = go opts { sortAlf = True } rest
        go opts ("--freqRel" : rest) = go opts { freqRel = True } rest
        go opts ("--file" : path : rest) = go opts { sourceType = File, source = path } rest
        go opts ("--text" : txt : rest) = go opts { sourceType = Text, source = txt } rest
        go _ ["--file"] = Left "--file precisa de um caminho"
        go _ ["--text"] = Left "--text precisa de um texto"
        go _ (x : _) = Left ("argumento desconhecido: " ++ x)

printaListaAteN :: Show a => [(String, a)] -> Int -> IO ()
printaListaAteN _ n | n <= 0 = return ()
printaListaAteN [] _ = return ()
printaListaAteN ((palavra, vezes) : rest) n = do
    putStrLn (palavra ++ ", " ++ show vezes)
    printaListaAteN rest (n - 1)

main :: IO ()
main = do
    args <- getArgs

    case parseArgs args of
        Left err -> do
            hPutStrLn stderr ("erro: " ++ err)
            exitFailure

        Right options -> do
            content <- case sourceType options of
                File -> readFile (source options)
                Text -> return (source options)

            let contentNormalizado = normalizacao content

            contentFinal <- if stopwords options
                then do
                    stopwordsContent <- readFile "stopwords.txt"
                    return (removeStopWords contentNormalizado stopwordsContent)
                else
                    return contentNormalizado

            let palavrasTotal = contaPalavras contentFinal
            let palavraVezes = contaPalavraVezes contentFinal

            let palavraVezesOrdenada = if sortAlf options then ordenacaoLetra palavraVezes else ordenacaoFrequencia palavraVezes

            putStrLn ("Quantidade total de palavras: " ++ show palavrasTotal)

            putStrLn "Quantas palavras deseja visualizar?"
            resposta <- getLine

            let quantidade = read resposta :: Int

            let resultado = if freqRel options then frequenciaRelativa palavraVezesOrdenada palavrasTotal else map (\(palavra, vezes) -> (palavra, fromIntegral vezes)) palavraVezesOrdenada

            printaListaAteN resultado quantidade
