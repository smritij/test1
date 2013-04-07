module Shapes.Polygon where

import Text.ParserCombinators.Parsec
import Data.Char
import Data.List
import Appearence.Color
import Appearence.Translate
import Appearence.Rotate
import Appearence.Scale
import Graphics.UI.GLUT
import Graphics.Rendering.OpenGL

eatSpaces::String -> String
eatSpaces [] =[]
eatSpaces (x:xs) | (isSpace x) = eatSpaces xs
                 | (x== ',') = eatSpaces xs
                 |otherwise = x:(eatSpaces xs)


polygonFound::[String] -> IO ()
polygonFound (x:xs)=let myPoints = (returnArgsPoly (read (eatSpaces x)) xs)
                                       in  parseRPolyArgs xs myPoints


returnArgsPoly::Int ->[String] -> [(GLfloat,GLfloat,GLfloat)]
returnArgsPoly 0 _ = []
returnArgsPoly a [] = []
returnArgsPoly a (x:xs) = (returnArgPoly x):(returnArgsPoly (a-1) xs)

myFunc::String -> (String,String)
myFunc [] =([],[])
myFunc (x:xs) = 
                if ((x == ',') || (x == '>'))
                 then ([],xs)
                 else
                  if (isSpace x)
                    then (fst(myFunc xs),snd(myFunc xs))
                    else (x:fst(myFunc xs),snd(myFunc xs))

returnArgPoly :: String -> (GLfloat,GLfloat,GLfloat)
returnArgPoly [] = (0.0,0.0,0.0)
returnArgPoly (x:xs) = if x== '<'
                         then let (y1,z1) = (myFunc xs)
                               in let (y2,z2 )= (myFunc z1)
                                    in let (y3,z3 )= (myFunc z2)
                                         in ((read y1) , (read y2) , (read y3)) 
                         else returnArgPoly xs



parseRPolyArgs [] myPoints= do currentColor $= Color4 1 0 0 0
                               hOpenGlPolygon myPoints
parseRPolyArgs (xs:xss) myPoints = do
                             if (isInfixOf "color rgb" xs )
                              then
                               let interm= snd(splitAt (head(elemIndices '<' xs)) xs)
                                in
                                  setColorRGB (fst (splitAt (head(elemIndices '>' xs)) interm))
                              else
                              
                                       if (isInfixOf "translate" xs )
                                         then
                                           let interm= snd(splitAt (head(elemIndices '<' xs)) xs)
                                            in
                                              translateImage (fst (splitAt (head(elemIndices '>' xs)) interm))
                                         else
                                            if (isInfixOf "rotate" xs )
                                             then
                                               let interm= snd(splitAt (head(elemIndices '<' xs)) xs)
                                                in
                                                  rotateImage (fst (splitAt (head(elemIndices '>' xs)) interm))
                                             else
                                              if (isInfixOf "scale" xs )
                                               then
                                                 let interm= snd(splitAt (head(elemIndices '<' xs)) xs)
                                                  in
                                                   scaleImage1 (fst (splitAt (head(elemIndices '>' xs)) interm))
                                               else     
                                                 parseRPolyArgs xss myPoints
                             hOpenGlPolygon myPoints
 

hOpenGlPolygon args = renderPrimitive Polygon $mapM_ (\(x, y, z)->vertex $ Vertex3 x y z) args
                      

