module Input where

import Time
import Keyboard
import Window

type Torque = None | CW | CCW
type alias Input = {
    window : (Int, Int),
    dt : Float,
    thrust: Bool,
    torque: Torque
}

type alias KeyMap = {
    thrust : Keyboard.KeyCode,
    torqueCW : Keyboard.KeyCode,
    torqueCCW : Keyboard.KeyCode
}

keymap = {
    thrust = 38, -- (up arrow)
    torqueCW = 39, -- (right arrow)
    torqueCCW = 37 -- (left arrow)
    }

keysToTorque : Bool -> Bool -> Torque
keysToTorque ccw cw = case (ccw, cw) of
    (True, True) -> None
    (False, False) -> None
    (True, False) -> CCW
    (False, True) -> CW

torque : Signal Torque
torque = Signal.map2 keysToTorque (Keyboard.isDown keymap.torqueCCW) (Keyboard.isDown keymap.torqueCW)

time = Signal.map Time.inSeconds (Time.fps 60)

input : Signal Input
input = Signal.map4 Input Window.dimensions time (Keyboard.isDown keymap.thrust) torque
