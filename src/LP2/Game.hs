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
            putStrLn "Resposta inválida."
            putStrLn "Sendo \"n\" um número entre 1 e 6. Insira no formato: ? n n n n \n" >> gameLoop turn secret        -- Loop
        else do
            modifyIORef' turn (+1)                                      -- Incrementa o turno
            if (input == secret)                                        -- Se entrada == segredo
                then do
                    turnInt <- readIORef turn                           -- Transforma IORef pra Int
                    putStrLn ("Parabéns, você acertou após " ++ show turnInt ++ " tentativas")
                else do
                    check secret input hits partial                     -- Verifica acertos/parciais 
                    hitsInt <- readIORef hits                           -- Transforma IORef pra Int
                    partialInt <- readIORef partial                     -- Transforma IORef pra Int
                    putStrLn (show hitsInt ++ " Completo, " ++ show partialInt ++ " Parcial")
                    gameLoop turn secret                                -- Proximo turno

-- Função para validar entrada
validate :: String -> IO (Bool)
validate input = do
    if(length input /= 7)                           -- Se entrada tem tamanho inválido
        then return False
        else do
            let pos0 = (input !! 0)
            let pos1 = (input !! 1)
            let pos2 = (input !! 2)
            let pos3 = (input !! 3)
            let pos4 = (input !! 4)
            let pos5 = (input !! 5)
            let pos6 = (input !! 6) 
            if( (pos0 >= '1' && pos0 <= '6') &&     -- Verifica intervalos
                (pos2 >= '1' && pos2 <= '6') &&
                (pos4 >= '1' && pos4 <= '6') &&
                (pos6 >= '1' && pos6 <= '6') &&
                (pos1 == ' ') &&                    -- Verifica espaços
                (pos3 == ' ') &&
                (pos5 == ' '))
                    then return True
                    else return False

-- Função para iniciar processo de encontrar acertos e parciais
check :: String -> String -> IORef Integer -> IORef Integer -> IO ()
check secret input hits partial = do
    open1 <- newIORef True                      -- Inicializa estado "aberto" da posição (Quando não acertou)
    open2 <- newIORef True
    open3 <- newIORef True
    open4 <- newIORef True
    hitPosition 0 secret input hits open1       -- Verifica se acertou valor da posição
    hitPosition 2 secret input hits open2
    hitPosition 4 secret input hits open3
    hitPosition 6 secret input hits open4
    marked1 <- newIORef False                      -- Auxiliar para marcar se ja foi encontrado parcial para aquela posição
    marked2 <- newIORef False
    marked3 <- newIORef False
    marked4 <- newIORef False
    partialPosition 0 secret input partial open1 open2 open3 open4 marked1 marked2 marked3 marked4    -- Verifica se valor é parcial de outro
    partialPosition 2 secret input partial open1 open2 open3 open4 marked1 marked2 marked3 marked4
    partialPosition 4 secret input partial open1 open2 open3 open4 marked1 marked2 marked3 marked4
    partialPosition 6 secret input partial open1 open2 open3 open4 marked1 marked2 marked3 marked4
 
-- Função para encontrar acertos
hitPosition :: Int -> String -> String -> IORef Integer -> IORef Bool -> IO ()
hitPosition pos secret input hits open = do
    if(input !! pos == secret !! pos)                       -- Se input[pos] == secret[pos]
        then do 
            writeIORef open False                           -- Muda estado da posição para fechado
            modifyIORef hits (+1)                           -- Incrementa o hits
        else return ()

-- Função para encontrar parciais
partialPosition :: Int -> String -> String -> IORef Integer -> IORef Bool -> IORef Bool -> IORef Bool -> IORef Bool -> IORef Bool -> IORef Bool -> IORef Bool -> IORef Bool -> IO ()
partialPosition pos secret input partial open1 open2 open3 open4 marked1 marked2 marked3 marked4 = do
    let input1 = (input !! 0)
    let input2 = (input !! 2)
    let input3 = (input !! 4)
    let input4 = (input !! 6)
    let secret1 = (secret !! 0)
    let secret2 = (secret !! 2)
    let secret3 = (secret !! 4)
    let secret4 = (secret !! 6)
    hit1 <- readIORef open1 
    hit2 <- readIORef open2
    hit3 <- readIORef open3
    hit4 <- readIORef open4
    partial1 <- readIORef marked1                           
    partial2 <- readIORef marked2
    partial3 <- readIORef marked3
    partial4 <- readIORef marked4
    if(pos == 0 && hit1)                                        -- Se (Digito 1 não esta completo)
        then do
            if(hit2 && not partial2 && input1 == secret2 )      -- (Digito 2 não esta completo) e (Digito 2 ainda não foi marcado como parcial) e (digito 1 = digito 2)
                then do
                    writeIORef marked2 True                     -- Marca digito 2 como parcial
                    modifyIORef partial (+1)                    -- Incrementa contador de parciais
                else do
                    if(hit3 && not partial3 && input1 == secret3)
                        then do
                            writeIORef marked3 True
                            modifyIORef partial (+1)
                        else do
                            if(hit4 && not partial4 && input1 == secret4)
                                then do
                                    writeIORef marked4 True
                                    modifyIORef partial (+1)
                                else return ()
        else do
            if(pos == 2 && hit2)
                then do
                    if(hit1 && not partial1 && input2 == secret1)
                        then do
                            writeIORef marked1 True
                            modifyIORef partial (+1)
                        else do
                            if(hit3 && not partial3 && input2 == secret3)
                                then do
                                    writeIORef marked3 True
                                    modifyIORef partial (+1)
                                else do
                                    if(hit4 && not partial4 && input2 == secret4)
                                        then do
                                            writeIORef marked4 True
                                            modifyIORef partial (+1)
                                        else return ()
                else do
                    if(pos == 4 && hit3)
                        then do
                            if(hit1 && not partial1 && input3 == secret1)
                                then do
                                    writeIORef marked1 True
                                    modifyIORef partial (+1)
                                else do
                                    if(hit2 && not partial2 && input3 == secret2)
                                        then do
                                            writeIORef marked2 True
                                            modifyIORef partial (+1)
                                        else do
                                            if(hit4 && not partial4 && input3 == secret4)
                                                then do
                                                    writeIORef marked4 True
                                                    modifyIORef partial (+1)
                                                else return ()
                        else do
                            if(pos == 6 && hit4)
                                then do
                                    if(hit1 && not partial1 && input4 == secret1)
                                        then do
                                            writeIORef marked1 True
                                            modifyIORef partial (+1)
                                        else do
                                            if(hit2 && not partial2 && input4 == secret2)
                                                then do
                                                    writeIORef marked2 True
                                                    modifyIORef partial (+1)
                                                else do
                                                    if(hit3 && not partial3 && input4 == secret3)
                                                        then do
                                                            writeIORef marked3 True
                                                            modifyIORef partial (+1)
                                                        else return ()
                                else return ()
     
