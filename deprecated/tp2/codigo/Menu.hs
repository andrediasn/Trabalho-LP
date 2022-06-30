-- Nome: Oromar Voit de Rezende
-- Matrícula: 201765122C
module Menu where

import Game (hasWinner, move, smartMove, start)
import System.Random (Random (randomRIO))

menu :: IO ()
menu = do
  putStrLn "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
  putStrLn "|------------|"
  putStrLn "| O Jogo Nim |"
  putStrLn "|------------|\n"
  putStrLn "Escolha a dificuldade"
  putStrLn "1- Fácil"
  putStrLn "2- Difícil"
  putStrLn "0- Sair"
  putStrLn "Opção: "

  opt <- getLine
  case opt of
    "1" -> do
      easyGame 0 start
      putStrLn "Pressione ENTER para retornar ao menu..."
      _ <- getLine
      menu
    "2" -> do
      hardGame 1 start
      putStrLn "Pressione ENTER para retornar ao menu..."
      _ <- getLine
      menu
    "0" -> return ()
    _ -> do
      putStrLn "Opção não existe. Aperte ENTER para continuar..."
      _ <- getLine
      menu

printGame game = do
  putStrLn "\n--------------"
  putStr "1 "
  putStrLn (concat (replicate (head game) "|"))
  putStr "2 "
  putStrLn (concat (replicate (game !! 1) "|"))
  putStr "3 "
  putStrLn (concat (replicate (game !! 2) "|"))
  putStr "4 "
  putStrLn (concat (replicate (game !! 3) "|"))
  putStrLn "\n"

easyGame turn game = do
  if hasWinner game
    then do
      putStrLn "O jogo terminou"
      if even turn
        then putStrLn "O computador venceu"
        else putStrLn "Você venceu"
    else do
      printGame game
      if even turn
        then playerMove game easyGame
        else randomMove game

hardGame turn game = do
  if hasWinner game
    then do
      putStrLn "O jogo terminou"
      if even turn
        then putStrLn "O computador venceu"
        else putStrLn "Você venceu"
    else do
      printGame game
      if even turn
        then playerMove game hardGame
        else bestMove game

getNum :: (Read a, Num a) => IO a
getNum = readLn

playerMove game mode = do
  putStrLn "Escolha a linha: "
  line <- getNum
  putStrLn "Escolha quantos palitos retirar: "
  qtd <- getNum
  if (==) game (move qtd line game)
    then playerMove game mode
    else mode 1 (move qtd line game)

randomMove game = do
  line <- randomRIO (1, 4) :: IO Int
  qtd <- randomRIO (1, game !! (-) line 1) :: IO Int
  if (==) game (move qtd line game)
    then randomMove game
    else do
      putStr "O computador removeu "
      putStr . show $ qtd
      putStr " palitos da linha "
      putStr . show $ line
      putStrLn "."
      easyGame 0 (move qtd line game)

bestMove game = do
  putStrLn "O computador fez o lance."
  hardGame 0 (smartMove game)