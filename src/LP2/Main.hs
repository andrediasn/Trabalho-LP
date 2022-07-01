-- Autores

-- Nome: André Dias Nunes
-- Matrícula: 201665570C

-- Nome: Gabriel Di iorio Silva
-- Matrícula: 201765551AC

module Main where

import Utilities (randomList, listToString)
import Game (gameLoop)
import Data.IORef



main :: IO ()
main = do 
    putStrLn "\n|------------|"
    putStrLn "| CriptoGame |"
    putStrLn "|------------|\n"
    listSecret <- randomList (4)
    let secret = listToString listSecret
    print (secret)
    putStrLn "Regras:"
    putStrLn " - Insira uma sequencia de 4 números"
    putStrLn " - Cada números separado por espaço"
    putStrLn " - Números dentro do intervalod de 1 a 6"
    turn <- newIORef 0       
    gameLoop turn secret
    





