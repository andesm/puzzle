import qualified Data.Map.Strict as Map
import Data.List.Split
import Data.Array
import Data.List
import Text.Printf
import Control.Monad
import Control.Monad.State
import Debug.Trace 

data Island = Island { maxColor :: Int
                     , prevChange :: Bool
                     , matrix :: IslandMatrix
                     , colorMap :: ChangeFromToMap }  deriving (Show)

type IslandMatrix = Array (Int, Int) Int
type ChangeFromToMap = Map.Map Int (Map.Map Int Int)
type ResultColorMap = Map.Map Int Int

printM :: Int -> Int -> State Island ()
printM  maxX maxY = do  
  i <- get
  forM (reverse [0..maxY]) $ \y -> do
    forM (reverse [0..maxX]) $ \x -> do
      traceShow (x, y, (matrix i) ! (x, y)) $ return ()
    traceShow "" $ return ()
  traceShow "" $ return ()

setPrevChange :: Bool -> State Island ()
setPrevChange x = do 
  i <- get
  let i' = i { prevChange = x }
  put i'

maxColorInc :: State Island ()
maxColorInc = do 
  i <- get
  let i' = i { maxColor = (maxColor i) + 1 }
  put i'

setColor :: Int -> Int -> Int -> State Island Island
setColor x y c = do
  i <- get
  let i' = i { matrix = (matrix i) // [((x, y), c)] }
  put i'
  return i'

getChangeColor :: ResultColorMap -> ChangeFromToMap -> Int -> ResultColorMap 
getChangeColor resultColorMap changeFromTomap color = 
  let resultColorMap' = Map.insert color (-1) resultColorMap
  in if Map.member color changeFromTomap
     then if Map.member color (changeFromTomap Map.! color) && 0 < changeFromTomap Map.! color Map.! color
          then Map.insert (changeFromTomap Map.! color Map.! color) (-1) resultColorMap'
          else foldl (\acc c -> Map.insert c (-1) acc) resultColorMap' .
               map (fst) .
               join .
               map (Map.toList) .
               map (getChangeColor resultColorMap' changeFromTomap) .
               filter (\c -> Map.notMember c resultColorMap') .
               map (fst) $
               (Map.toList (changeFromTomap Map.! color))
     else resultColorMap'

setChangeFromToHash :: Int -> Int-> State Island ()
setChangeFromToHash x y = do
  i <- get
  let cm = colorMap i
      m = matrix i
      i1 = m ! (x, y)
      i2 = m ! (x ,y - 1)
      cm' = if Map.member i1 cm
            then Map.insert i1 (Map.insert i1 (-1) (cm Map.! i1)) cm
            else Map.insert i1 (Map.insert i1 (-1) Map.empty) cm
      cm'' = Map.insert i1 (Map.insert i2 (-1) (cm' Map.! i1)) cm'
      cm''' = if Map.member i2 cm
              then Map.insert i2 (Map.insert i1 (-1) (cm Map.! i2)) cm''
              else Map.insert i2 (Map.insert i1 (-1) Map.empty) cm''
      i' = i { colorMap = cm''' }
  put i'
  return ()

setChangeFromToHashColor :: Int -> Int-> Int -> State Island ()
setChangeFromToHashColor x y c = do
  i <- get
  let cm = colorMap i
      m = matrix i
      i1 = m ! (x, y)
      cm' = if Map.member i1 cm
            then Map.insert i1 (Map.insert i1 (-1) (cm Map.! i1)) cm
            else cm
      i' = i { colorMap = cm' }
  put i'
  return ()

searchIsland :: Int -> Int -> State Island ()
searchIsland maxX maxY = do
  forM [0..maxY] $ \y -> do
    maxColorInc
    forM [0..maxX] $ \x -> do
      i <- get
      if (matrix i) ! (x, y) /= 0
        then do i <- if x /= 0 && (matrix i) ! (x - 1, y) /= 0
                     then setColor x y ((matrix i) ! (x - 1, y))
                     else setColor x y (maxColor i)
                when (y /=0 && (matrix i) ! (x, y - 1) /= 0) $ do
                  setChangeFromToHash x y 
                  return ()
                setPrevChange True
        else do when (prevChange i) $ do
                  maxColorInc
                  return ()
                setPrevChange False

  forM [0..maxY] $ \y -> do
    forM [0..maxX] $ \x -> do
      i <- get
      let resultColorMap = Map.empty
          mc = Map.findMin (getChangeColor resultColorMap (colorMap i) ((matrix i) ! (x, y)))
      setChangeFromToHashColor x y (fst mc)
      setColor x y (fst mc)
  return ()

countIsland :: Island -> Int
countIsland i =
  let m = matrix i
  in length . nub . filter (/=0) $ elems m

main = do 
  contents <- getContents
  let x = map (map (\x -> read x :: Int)) $ map (splitOn " ") (lines contents)
      d = head x
      maxX = (d !! 0) - 1
      maxY = (d !! 1) - 1
      m = array ((0,0), (maxX, maxY)) [((i,j), ((tail x) !! j) !! i) | i <- [0..maxX], j <- [0..maxY]]
  let i = Island { maxColor = 0
                 , prevChange = False
                 , matrix = m
                 , colorMap = Map.empty }
      (r, i') = runState (searchIsland maxX maxY) i
      c = countIsland i'
  print c
  
