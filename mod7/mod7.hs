import Data.List.Split
import Data.List
import Text.Printf
import Debug.Trace 
import Control.Monad

main = do 
  contents <- getContents
  let x = map (map (\x -> read x :: Int)) $ map (splitOn " ") (lines contents)
      n = head x
      list = join $ (tail x)
  print (length [ (a,b,c) | a <- list, b <- list, c <- list, a > b, b > c,  (a + b + c) `mod` 7 == 0])

