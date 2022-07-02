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
    hits <- newIORef 0                                                  -- Inicializa contador de acertos
    partial <- newIORef 0                                               -- Inicializa contador de parciais                                    
    putStr "? "
    input <- getLine                                                    -- Entrada
    valid <- validate (input)                                           -- Verifica entrada
    if (valid)
        then do
            putStrLn "Entrada inválida."
            putStrLn "Sendo \"n\" um número entre 1 e 6. Insira no formato: n n n n" >> gameLoop turn secret        -- Loop
        else do
            modifyIORef' turn (+1)
            if (input == secret)
                then do
                    putStr ("Parabéns, você acertou após ")
                    readIORef turn >>= print
                    -- putStrLn (" tentativas")  -- ?? Como printar na msm linha
                else do
                    check secret input hits partial
                    putStr "Completos: "
                    readIORef hits >>= print
                    gameLoop turn secret
                    -- putStr "Parciais: " >> gameLoop turn secret
                    -- readIORef partial >>= print

-- Função para iniciar processo de encontrar acertos e parciais
check :: String -> String -> IORef Integer -> IORef Integer -> IO ()
check secret input hits partial = do
    open1 <- newIORef True
    open2 <- newIORef True
    open3 <- newIORef True
    open4 <- newIORef True
    hitPosition 0 secret input hits open1
    hitPosition 2 secret input hits open2
    hitPosition 4 secret input hits open3
    hitPosition 6 secret input hits open4
 
-- Função para encontrar acertos
hitPosition :: Int -> String -> String -> IORef Integer -> IORef Bool -> IO ()
hitPosition pos secret input hits open = do
    if(input !! pos == secret !! pos)                       -- Se input[pos] == secret[pos]
        then do 
            writeIORef open False                           -- Muda estado do digito para fechado
            modifyIORef hits (+1)                           -- Incrementa o hits
        else 
            return ()

-- partialPosition :: String -> String -> IORef Integer -> IORef Bool -> IORef Bool -> IORef Bool -> IORef Bool -> IO ()
-- partialPosition secret input partial open1 open2 open3 open4 = do
    

validate :: String -> IO (Bool)
validate input = do
    if(length input /= 7)
        then return True
        else return False


-- then if(input !! 0 >= 1 && input !! 0 <= 6)
-- validateRange :: 