-- Autores

-- Nome: André Dias Nunes
-- Matrícula: 201665570C

-- Nome: Gabriel Di iorio Silva
-- Matrícula: 201765551AC

module Game where
import Data.IORef

gameLoop :: IORef Integer -> String -> IO ()
gameLoop turn secret = do                                              
    hits <- newIORef 0                                                  -- Inicializa contador de acertos
    partial <- newIORef 0                                               -- Inicializa contador de parciais                                    
    putStr "? "
    input <- getLine                                                    -- Entrada
    valid <- validate (input)                                           -- Verifica entrada
    if (not valid)
        then do
            putStrLn "Entrada inválida."
            putStrLn "Sendo \"n\" um número entre 1 e 6. Insira no formato: ? n n n n \n" >> gameLoop turn secret        -- Loop
        else do
            modifyIORef' turn (+1)                                      -- Incrementa o turno
            if (input == secret)                                        -- Se entrada == segredo
                then do
                    turnInt <- readIORef turn
                    putStrLn ("Parabéns, você acertou após " ++ show turnInt ++ " tentativas")
                else do
                    check secret input hits partial                     -- Verifica acertos/parciais 
                    putStr "Completos: "
                    readIORef hits >>= print
                    gameLoop turn secret                                -- Proximo turno
                    -- putStr "Parciais: " >> gameLoop turn secret
                    -- readIORef partial >>= print

-- Função para iniciar processo de encontrar acertos e parciais
check :: String -> String -> IORef Integer -> IORef Integer -> IO ()
check secret input hits partial = do
    open1 <- newIORef True                      -- Inicializa estado "aberto" da posição
    open2 <- newIORef True
    open3 <- newIORef True
    open4 <- newIORef True
    hitPosition 0 secret input hits open1       -- Verifica se acertou valor da posição
    hitPosition 2 secret input hits open2
    hitPosition 4 secret input hits open3
    hitPosition 6 secret input hits open4
    -- partialPosition secret input partial open1 open2 open3 open4
 
-- Função para encontrar acertos
hitPosition :: Int -> String -> String -> IORef Integer -> IORef Bool -> IO ()
hitPosition pos secret input hits open = do
    if(input !! pos == secret !! pos)                       -- Se input[pos] == secret[pos]
        then do 
            writeIORef open False                           -- Muda estado da posição para fechado
            modifyIORef hits (+1)                           -- Incrementa o hits
        else return ()

-- partialPosition :: String -> String -> IORef Integer -> IORef Bool -> IORef Bool -> IORef Bool -> IORef Bool -> IO ()
-- partialPosition secret input partial open1 open2 open3 open4 = do
--     if(open1)
--         then print ("open1 true")

    
-- Função para validar entrada
validate :: String -> IO (Bool)
validate input = do
    if(length input /= 7)
        then return False
        else do
            let pos0 = (input !! 0)
            let pos1 = (input !! 1)
            let pos2 = (input !! 2)
            let pos3 = (input !! 3)
            let pos4 = (input !! 4)
            let pos5 = (input !! 5)
            let pos6 = (input !! 6) 
            if( (pos0 >= '1' && pos0 <= '6') &&
                (pos2 >= '1' && pos2 <= '6') &&
                (pos4 >= '1' && pos4 <= '6') &&
                (pos6 >= '1' && pos6 <= '6') &&
                (pos1 == ' ') &&
                (pos3 == ' ') &&
                (pos5 == ' '))
                    then return True
                    else return False