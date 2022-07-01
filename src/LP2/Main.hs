-- Autores

-- Nome: André Dias Nunes
-- Matrícula: 201665570C

-- Nome: Gabriel Di iorio Silva
-- Matrícula: 201765551AC

module Main where
import System.Random (randomRIO)
import Data.Char (digitToInt)



main :: IO ()
main = do 
    putStrLn "\n|------------|"
    putStrLn "| CriptoGame |"
    putStrLn "|------------|\n"
    code <- randomList (4)
    print (code !! 1)
    putStrLn ("Digite o Codigo:")
    input <- getLine
    
    putStrLn ("CodeAnswer: " ++ input)
    -- putStrLn ("Pos1: " ++ code !! 1)


randomList :: Int -> IO([Int])
randomList 0 = return []
randomList n = do
  r  <- randomRIO (1,6)
  rs <- randomList (n-1)
  return (r:rs)

-- myShow :: String -> String
-- myShow s = concat ["[", intersperse ',' s, "]"]

-- gameLoop :: [Int] -> IO ()
-- gameLoop code = do
--     i <- fmap read getLine
--     map digitToInt i
--     if i == code 
--         then putStrLn "You got it!"
--         else putStrLn "Nope. Guess again." >> gameLoop code


