import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO (hPutStrLn, stderr)

data SourceType = File | Text
    deriving (Enum, Show, Eq)

data Options = Options {
    stopwords  :: Bool,
    sortOutput :: Bool,
    sourceType :: SourceType,
    source     :: String
} deriving (Show)

defaultOptions :: Options
defaultOptions = Options
  { stopwords  = False
  , sortOutput = False
  , sourceType = Text
  , source     = ""
  }

parseArgs :: [String] -> Either String Options
parseArgs = go defaultOptions
  where
    go opts []
      | null (source opts) = Left "falta a fonte: use --file <caminho> ou --text <texto>"
      | otherwise          = Right opts
    go opts ("--stopwords" : rest)   = go opts { stopwords = True } rest
    go opts ("--sort" : rest)        = go opts { sortOutput = True } rest
    go opts ("--file" : path : rest) = go opts { sourceType = File, source = path } rest
    go opts ("--text" : txt : rest)  = go opts { sourceType = Text, source = txt } rest
    go _ ["--file"]                  = Left "--file precisa de um caminho"
    go _ ["--text"]                  = Left "--text precisa de um texto"
    go _ (x : _)                     = Left ("argumento desconhecido: " ++ x)

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
      print options
      putStrLn content