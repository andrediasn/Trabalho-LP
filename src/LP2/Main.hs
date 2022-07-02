-- Autores

-- Nome: André Dias Nunes
-- Matrícula: 201665570C

-- Nome: Gabriel Di iorio Silva
-- Matrícula: 201765551AC

module Main where

import Data.IORef
import System.Random (randomRIO)

import Game (gameLoop)

main :: IO ()
main = do 
    menu
    listSecret <- randomList (4)                                -- Gera lista de [1..6]
    let secret = listToString listSecret                        -- Converte para string
    --putStrLn ("Segredo: " ++ show secret2 ++ "\n")            -- Descomente para exibir o segredo gerado
    turn <- newIORef 0                                          -- Inicializa contador de turnos       
    gameLoop turn secret                                        -- Inicia o jogo
    
menu = do
    putStrLn "\n          |~~~~~~~~~~~~|"
    putStrLn "          | CriptoGame |"
    putStrLn "          |~~~~~~~~~~~~|\n"
    putStrLn "Regras:"
    putStrLn " - Descubra o segredo"
    putStrLn " - Insira uma sequencia de 4 números"
    putStrLn " - Cada números separado por um espaço"
    putStrLn " - Números dentro do intervalo de 1 a 6\n"

-- Gera lista de números aleatórios
randomList :: Int -> IO([Int])
randomList 0 = return []
randomList n = do
    r  <- randomRIO (1,6)
    rs <- randomList (n-1)
    return (r:rs)

-- Transforma lista para string
listToString :: (Show a) => [a] -> String
listToString [] = ""
listToString [x] = (show x)
listToString (x:xs) = (show x) ++ " " ++ listToString xs