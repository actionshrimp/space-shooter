module Game where

import Types exposing (..)
import Player exposing (defaultPlayer)
import Shots exposing (defaultShots)
import Asteroids exposing (defaultAsteroids)

defaultGame : Game
defaultGame = {
    window = { x = 0, y = 0 },
    t = 0,
    player = defaultPlayer,
    shots = defaultShots,
    asteroids = defaultAsteroids
  }
