import Signal

import Types exposing (..)
import Game exposing (defaultGame)
import Render exposing (render)
import Update exposing (update)
import Input exposing (input)
import Graphics.Element exposing (Element)

type alias Coords = { x : Float, y : Float }

gameState : Signal Game
gameState = Signal.foldp update defaultGame input

main : Signal Element
main = Signal.map render gameState
