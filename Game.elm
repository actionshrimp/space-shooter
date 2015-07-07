module Game where

type alias Coords = { x : Float, y : Float }
type alias Game = {
    window : Coords,
    t : Float,
    player : {
        ship : {
            rear_thruster_power : Float,
            side_thruster_power : Float,
            max_vel : Float
            },
        pos : Coords,
        vel : Coords,
        angle : Float
    }
}

defaultGame : Game
defaultGame = {
    window = { x = 0, y = 0 },
    t = 0,
    player = {
        ship = {
            rear_thruster_power = 250,
            side_thruster_power = 5,
            max_vel = 250
            },
        pos = { x = 0, y = 0 },
        vel = { x = 0, y = 0 },
        angle = 0
    }
  }
