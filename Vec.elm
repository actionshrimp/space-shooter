module Vec where

import Random
import Types exposing (..)

genVec : Float -> Float -> Float -> Float -> Random.Generator Vec
genVec x0 x1 y0 y1 = Random.customGenerator <| \s0 ->
    let (rX, s1) = Random.generate (Random.float x0 x1) s0
        (rY, s2) = Random.generate (Random.float y0 y1) s1
    in ({ x = rX, y = rY }, s2)

bounded : Float -> Float -> Float -> Float -> Vec -> Vec
bounded w0 w1 h0 h1 { x, y } = 
    let w = w1 - w0
        h = h1 - h0
    in {
        x = if x > w1 then x - w else if x < w0 then x + w else x,
        y = if y > h1 then y - h else if y < h0 then y + h else y
    }

windowBounded : (Int, Int) -> Vec -> Vec
windowBounded win v =
    let winW = toFloat <| fst win
        winH = toFloat <| snd win
        wx1 = winW / 2
        wy1 = winH / 2
        wx0 = negate wx1
        wy0 = negate wy1
    in bounded (-winW / 2) (winW / 2) (-winH / 2) (winH / 2) v

magBounded : Float -> Vec -> Vec
magBounded b v =
    if (mag v) > 0
       then let m = min b (mag v) in mul m (norm v)
       else v


add : Vec -> Vec -> Vec
add u v = { x = u.x + v.x, y = u.y + v.y }

sub : Vec -> Vec -> Vec
sub u v = { x = u.x - v.x, y = u.y - v.y }

mag : Vec -> Float
mag v = sqrt (v.x * v.x + v.y * v.y)

norm : Vec -> Vec
norm v = let m = mag v in { x = v.x / m, y = v.y / m }

zero : Vec
zero = { x = 0, y = 0 }

dot : Vec -> Vec -> Float
dot u v = u.x * v.x + u.y + v.y

mul : Float -> Vec -> Vec
mul f v = { x = v.x * f, y = v.y * f }

reflect : Vec -> Vec -> Vec
reflect v n = add v (mul (-2 * dot n v) n)
