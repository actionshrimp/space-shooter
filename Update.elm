module Update where

import Types exposing (..)
import Player exposing (updatePlayer)
import Shots exposing (updateShots, addNewShots)
import Asteroids exposing (updateAsteroids)
import Random

updateWindow : Input -> Game -> Game
updateWindow { window } g = { g | window <- {
        x = toFloat (fst window),
        y = toFloat (snd window)
    } }

updateTime : Input -> Game -> Game
updateTime { dt } ({ t } as g) = { g | t <- t + dt }


update : Input -> Game -> Game
update i g = g
    |> (updateWindow i)
    |> (updateTime i)
    |> (updatePlayer i)
    |> (updateShots i)
    |> (addNewShots i)
    |> (updateAsteroids i)
