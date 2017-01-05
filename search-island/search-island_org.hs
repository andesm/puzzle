import Data.List.Split
import Data.Array
import Data.List
import Text.Printf
import Control.Monad
import Control.Monad.State
import Debug.Trace 

data Island = Island { maxColor :: Int
                     , prevChange :: Bool
                     , matrix :: Array (Int, Int) Int }  deriving (Show)

setPrevChangeFalse :: State Island ()
setPrevChangeFalse = do 
  i <- get
  let i' = i { prevChange = False }
  put i'
  
changeIslandColor ::  Int -> Int -> Int -> Int -> State Island ()
changeIslandColor x y fromColor toColor = do
  i <- get
  let m = matrix i
      m' = if m ! (x, y) == fromColor
           then m // [((x, y), toColor)]
           else m
      i' = i { matrix = m'}
  put i'
  
changeIslandColorAll :: Int -> Int -> Int -> State Island ()
changeIslandColorAll x y toColor = do
  i <- get
  let m = matrix i
      (_, (maxX, maxY)) = bounds m
      fromColor = m ! (x, y)
  if y < 1 || fromColor == 0
    then return ()
    else do forM [1..maxY] $ \y -> 
              forM [1..maxX] $ \x -> changeIslandColor x y fromColor toColor
            return ()

searchIslandColor :: Int -> Int -> State Island Int
searchIslandColor x y = do
  i <- get
  let m = matrix i
      oc = m ! (x, y)
      lc = m ! (x - 1, y)
      mc = if (prevChange i) && oc == 0
           then (maxColor i) + 1
           else (maxColor i)
      pc = if oc == 0 
           then False
           else True
      oc' = if oc == 0
            then 0
            else if lc == 0
                 then (maxColor i)
                 else lc
      m' = m // [((x, y), oc')]
      i' = Island { maxColor = mc
                  , prevChange = pc
                  , matrix = m'}
  put i'
  return oc'

searchIslandX :: Int -> Int -> State Island ()
searchIslandX x y = do
  i <- get
  let m = matrix i
      (_, (maxX, maxY)) = bounds m
  if maxX < x
    then return ()
    else do oc <- searchIslandColor x y
            if oc == 0
              then return ()
              else changeIslandColorAll x (y - 1) oc
            searchIslandX (x + 1) y

searchIslandY :: Int -> State Island ()
searchIslandY y = do
  i <- get
  let m = matrix i
      (_, (maxX, maxY)) = bounds m
  if maxY < y
    then return ()
    else do setPrevChangeFalse
            searchIslandX 1 y
            searchIslandY (y + 1)

countIsland :: Island -> Int
countIsland i =
  let m = matrix i
  in length . nub . filter (/=0) $ elems m

main = do 
  contents <- getContents
  let x = map (map (\x -> read x :: Int)) $ map (splitOn " ") (lines contents)
      d = head x
      xm = d !! 0
      ym = d !! 1
      x' = map (\y -> [0] ++ y ++ [0]) x
      m = array ((0,1), (xm + 1, ym)) [((i,j), ((tail x') !! (j - 1)) !! i) | i<-[0..xm + 1], j<-[1..ym]]
      i = Island { maxColor = 2
                 , prevChange = False
                 , matrix = m}
      (r, i') = runState (searchIslandY 1) i
      c = countIsland i'
  print c
  
