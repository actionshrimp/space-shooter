module Game where

type alias Coords = { x : Float, y : Float }
type alias Game = {
    window : Coords,
    t : Float,
    v : Coords,
    s : Coords
}

defaultGame : Game
defaultGame = {
    window = { x = 0, y = 0 },
    t = 0,
    v = { x = 0, y = 0 },
    s = { x = 0, y = 0 }
  }
