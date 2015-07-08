module Input where

import Time
import Keyboard
import Window

type Torque = None | CW | CCW
type alias Input = {
    window : (Int, Int),
    dt : Float,
    thrust : Bool,
    torque : Torque,
    firing : Bool
}

type alias KeyMap = {
    thrust : Keyboard.KeyCode,
    torqueCW : Keyboard.KeyCode,
    torqueCCW : Keyboard.KeyCode,
    fire : Keyboard.KeyCode
}

keymap = {
    thrust = 38, -- (up arrow)
    torqueCW = 39, -- (right arrow)
    torqueCCW = 37, -- (left arrow)
    fire = 32 -- (space)
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

time = Signal.map Time.inSeconds (Time.fps 60)

input : Signal Input
input = Signal.sampleOn time (Signal.map5 Input Window.dimensions time thrust torque fire)
