-- Autores

-- Nome: André Dias Nunes
-- Matrícula: 201665570C

-- Nome: Gabriel Di iorio Silva
-- Matrícula: 201765551AC

module Utilities where
import System.Random (randomRIO)

randomList :: Int -> IO([Int])
randomList 0 = return []
randomList n = do
    r  <- randomRIO (1,6)
    rs <- randomList (n-1)
    return (r:rs)

listToString :: (Show a) => [a] -> String
listToString [] = ""
listToString [x] = (show x)
listToString (x:xs) = (show x) ++ " " ++ listToString xs

-- increment :: Int -> Int
-- increment n = do
--     i <- newIORef n       
--     modifyIORef i (+1)    
--     return (i)