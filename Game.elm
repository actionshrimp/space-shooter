module Game where

import Random

type alias Coords = { x : Float, y : Float }

type alias Shot = {
    pos : Coords,
    vel : Coords,
    firedAt: Float,
    angle: Float
}

type alias Player = {
    rearThrusterPower : Float,
    sideThrusterPower : Float,
    maxVel : Float,
    shotSpeed: Float,
    shotAge: Float,
    shotWiggle: Float,
    shotRate: Float,
    pos : Coords,
    vel : Coords,
    angle : Float
}


type alias Game = {
    window : Coords,
    t : Float,
    player : Player,
    shots: List Shot,
    shotWiggleSeed : Random.Seed
}

defaultGame : Game
defaultGame = {
    window = { x = 0, y = 0 },
    t = 0,
    player = {
        rearThrusterPower = 500,
        sideThrusterPower = 5,
        maxVel = 500,
        shotSpeed = 1500,
        shotAge = 1,
        shotWiggle = 0.02,
        shotRate = 10,
        pos = { x = 0, y = 0 },
        vel = { x = 0, y = 0 },
        angle = 0
    },
    shots = [],
    shotWiggleSeed = Random.initialSeed 0
  }
