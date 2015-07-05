module Update where

import Game exposing (Game)
import Input exposing (Input)

accel = { x = 50, y = 50 }

update : Input -> Game -> Game
update { dt, keys, window } g = let
    window' = { x = toFloat (fst window), y = toFloat (snd window) }
    t' = g.t + dt
    v' = { x = g.v.x + accel.x * (toFloat keys.x) * dt, y = g.v.y + accel.y * (toFloat keys.y) * dt }
    s' = { x = g.s.x + v'.x * dt, y = g.s.y + v'.y * dt }
  in { g | t <- t', v <- v', s <- s', window <- window' }
