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
windowBounded window v =
    let winW = toFloat <| fst window
        winH = toFloat <| snd window
        wx1 = winW / 2
        wy1 = winH / 2
        wx0 = negate wx1
        wy0 = negate wy1
    in bounded wx0 wx1 wy0 wy1 v
