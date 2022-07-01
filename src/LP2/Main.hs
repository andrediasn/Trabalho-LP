-- Autores

-- Nome: André Dias Nunes
-- Matrícula: 201665570C

-- Nome: Gabriel Di iorio Silva
-- Matrícula: 201765551AC

module Main where

import Utilities (randomList, listToString)



main :: IO ()
main = do 
    putStrLn "\n|------------|"
    putStrLn "| CriptoGame |"
    putStrLn "|------------|\n"
    listSecret <- randomList (4)
    let secret = listToString listSecret
    print (secret)
    putStrLn ("Tentativa:")
    --gameLoop 0 secret
    

-- gameLoop :: String -> IO ()
-- gameLoop turn secret = do
--     input <- getLine
--     if (length input /= 7)
--     if (input == secret)
--         then putStrLn "Parabéns, você acertou após 4 tentativas."
--         else putStrLn "Nope. Guess again." >> gameLoop secret






