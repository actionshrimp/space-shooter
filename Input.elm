module Input where

import Time
import Keyboard
import Window
import Types exposing (..)
import Signal exposing ((<~), (~))

type alias KeyMap = {
    thrust : Keyboard.KeyCode,
    torqueCW : Keyboard.KeyCode,
    torqueCCW : Keyboard.KeyCode,
    stop : Keyboard.KeyCode,
    fire : Keyboard.KeyCode
}

keymap = {
    thrust = 38, -- (up arrow)
    torqueCW = 39, -- (right arrow)
    torqueCCW = 37, -- (left arrow)
    stop = 32, -- (space)
    fire = 16 -- (shift)
    }

keysToTorque : Bool -> Bool -> Torque
keysToTorque ccw cw = case (ccw, cw) of
    (True, True) -> None
    (False, False) -> None
    (True, False) -> CCW
    (False, True) -> CW

torque : Signal Torque
torque = Signal.map2 keysToTorque (Keyboard.isDown keymap.torqueCCW) (Keyboard.isDown keymap.torqueCW)

thrust : Signal Bool
thrust = Keyboard.isDown keymap.thrust

fire : Signal Bool
fire = Keyboard.isDown keymap.fire

stop : Signal Bool
stop = Keyboard.isDown keymap.stop

time = Signal.map Time.inSeconds (Time.fps 60)

input : Signal Input
input = Signal.sampleOn time (Input <~ Window.dimensions ~ time ~ thrust ~ torque ~ stop ~ fire)
