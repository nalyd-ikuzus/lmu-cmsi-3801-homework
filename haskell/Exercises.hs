module Exercises
    ( change,
    firstThenApply,
    powers,
    meaningfulLineCount,
    size,
    contains,
    inorder,
    insert,
    BST(Empty),
    Shape(Sphere, Box),
    volume,
    surfaceArea,
    ) where

import qualified Data.Map as Map
import Data.Text (pack, unpack, replace)
import Data.List(isPrefixOf, find)
import Data.Char(isSpace)

change :: Integer -> Either String (Map.Map Integer Integer)
change amount
    | amount < 0 = Left "amount cannot be negative"
    | otherwise = Right $ changeHelper [25, 10, 5, 1] amount Map.empty
        where
          changeHelper [] remaining counts = counts
          changeHelper (d:ds) remaining counts =
            changeHelper ds newRemaining newCounts
              where
                (count, newRemaining) = remaining `divMod` d
                newCounts = Map.insert d count counts

firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply xs pred f = fmap f (find pred xs)

powers :: (Integral i) => i -> [i]
powers base = map (base^) [0..]


-- Helper function to strip the leading whitespace of a string
leadingStrip = dropWhile (`elem` " \t")

meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount path = do
  contents <- readFile path -- Read contents of the file
  return $ length $ filter meaningfulLine $ lines contents -- Filter based on meaningfulLine definition, count those lines, and return
  where
    meaningfulLine line = not (all isSpace line) && not ("#" `isPrefixOf` (leadingStrip line)) -- A meaningfulLine is defined as a non-empty line where the first character isn't "#"

data Shape 
  = Sphere Double
  | Box Double Double Double
  deriving (Eq, Show)

volume :: Shape -> Double
volume (Sphere r) = (4 * pi * r^3) / 3
volume (Box l w h) = l * w * h

surfaceArea :: Shape -> Double
surfaceArea (Sphere r) = 4 * pi * r^2
surfaceArea (Box l w h) = 2 * ((l * w) + (w * h) + (h * l))


data BST a 
  = Empty
  | Node a (BST a) (BST a)

size :: BST a -> Int
size Empty = 0
size (Node _ left right) = 1 + size left + size right

contains :: Ord a => a -> BST a -> Bool
contains _ Empty = False
contains value (Node nodeValue left right)
  | value < nodeValue = contains value left
  | value > nodeValue = contains value right
  | otherwise = nodeValue == value

inorder :: BST a -> [a]
inorder Empty = []
inorder (Node value left right) = inorder left ++ [value] ++ inorder right

insert :: Ord a => a -> BST a -> BST a
insert value Empty = Node value Empty Empty
insert value (Node nodeValue left right)
  | value < nodeValue = Node nodeValue (insert value left) right
  | value > nodeValue = Node nodeValue left (insert value right)
  | otherwise = Node nodeValue left right

instance (Show a) => Show (BST a) where
  show :: Show a => BST a -> String
  show Empty = "()"
  show (Node value left right)
    | size left == 0 && size right == 0 = "(" ++ show value ++ ")"
    | size left == 0 = "(" ++ show value ++ show right ++ ")"
    | size right == 0 = "(" ++ show left ++ show value ++ ")"
    | otherwise = "(" ++ show left ++ show value ++ show right ++ ")"
