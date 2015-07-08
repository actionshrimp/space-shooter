module Game where

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
    pos : Coords,
    vel : Coords,
    angle : Float
}


type alias Game = {
    window : Coords,
    t : Float,
    player : Player,
    shots: List Shot
}

defaultGame : Game
defaultGame = {
    window = { x = 0, y = 0 },
    t = 0,
    player = {
        rearThrusterPower = 500,
        sideThrusterPower = 5,
        maxVel = 500,
        shotSpeed = 750,
        shotAge = 1,
        pos = { x = 0, y = 0 },
        vel = { x = 0, y = 0 },
        angle = 0
    },
    shots = []
  }
