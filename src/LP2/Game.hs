-- Autores

-- Nome: André Dias Nunes
-- Matrícula: 201665570C

-- Nome: Gabriel Di iorio Silva
-- Matrícula: 201765551AC

module Game where
--import Utilities (increment)
import Data.IORef

gameLoop :: IORef Integer -> String -> IO ()
gameLoop turn secret = do
    putStr "? "
    input <- getLine
    if (length input /= 7)
        then putStrLn "Entrada inválida." >> gameLoop turn secret
        else do
            modifyIORef turn (+1)
            if (input == secret)
                then do
                    putStr ("Parabéns, você acertou após ")
                    readIORef turn >>= print
                    -- putStrLn (" tentativas")  -- ?? Como printar na msm linha
                else putStrLn "Nope. Guess again." >> gameLoop turn secret

