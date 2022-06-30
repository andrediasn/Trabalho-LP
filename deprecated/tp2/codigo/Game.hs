-- Nome: Oromar Voit de Rezende
-- Matrícula: 201765122C
module Game where

import Data.List (maximumBy)
import Data.Ord (comparing)

start :: [Int]
start = [1, 3, 5, 7]

move qtd line = zipWith (\idx ele -> if (line == idx) && (qtd <= ele) && (qtd >= 0) then (-) ele qtd else ele) [1 ..]

hasWinner game = (==) game [0, 0, 0, 0]

decToBin :: Int -> [Int]
decToBin dec = [mod (div dec 4) 2, mod (div dec 2) 2, mod dec 2]

isSmart game =
  all
    even
    ( zipWith
        (+)
        (decToBin (head game))
        ( zipWith
            (+)
            (decToBin (game !! 1))
            (zipWith (+) (decToBin (game !! 2)) (decToBin (game !! 3)))
        )
    )

smartMove game
  | game !! 3 >= 1 = smartMoveR (game !! 3) 4 game
  | game !! 2 >= 1 = smartMoveR (game !! 2) 3 game
  | game !! 1 >= 1 = smartMoveR (game !! 1) 2 game
  | head game >= 1 = smartMoveR (head game) 1 game
  | otherwise = [0, 0, 0, 0]

smartMoveR qtd line game
  | line == 0 && game !! 3 > 0 = move 1 (snd (maxi game)) game
  | hasWinner (move qtd line game) = move qtd line game
  | qtd < 1 = smartMoveR (game !! (line - 2)) (line - 1) game
  | isSmart (move qtd line game) = move qtd line game
  | otherwise = smartMoveR (qtd - 1) line game

maxi xs = maximumBy (comparing fst) (zip xs [1 ..])