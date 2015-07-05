module Input where

import Time
import Keyboard
import Window

type alias Input = { window : (Int, Int), dt : Float, keys : Keys }
type alias Keys = { x : Int, y : Int }

time = Signal.map Time.inSeconds (Time.fps 60)

input : Signal Input
input = Signal.map3 Input Window.dimensions time Keyboard.arrows
