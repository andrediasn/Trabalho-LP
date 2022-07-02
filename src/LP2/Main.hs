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
    menu
    listSecret <- randomList (4)                                -- Gera lista de [1..6]
    let secret = listToString listSecret                        -- Converte para string
    print (secret)                                              -- Segredo
    turn <- newIORef 0                                          -- Inicializa contador de turnos       
    gameLoop turn secret                                        -- Inicia o jogo
    


menu = do
    putStrLn "\n|------------|"
    putStrLn "| CriptoGame |"
    putStrLn "|------------|\n"
    putStrLn "Regras:"
    putStrLn " - Insira uma sequencia de 4 números"
    putStrLn " - Cada números separado por espaço"
    putStrLn " - Números dentro do intervalod de 1 a 6"


