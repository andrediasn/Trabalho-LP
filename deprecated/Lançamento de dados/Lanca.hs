module Main where

import System.Random (randomRIO)

main :: IO ()
main = do
    putStrLn "Lançamento de dois dados"
    x <- randomRIO (1,6::Int)
    y <- randomRIO (1,6)
    putStrLn ("Faces obtidas: " ++ show x ++ " e " ++ show (y::Int))