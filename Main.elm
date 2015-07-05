import Color exposing (..)
import Graphics.Collage exposing (collage, toForm, rect, filled, Form, move)
import Graphics.Element exposing (Element, show)
import Time
import Signal
import Window
import Keyboard

ship : { x : Float, y : Float } -> Form
ship { x, y }= rect 10 10 |> filled (rgb 200 0 0) |> move (x, y)

bg w h = rect (toFloat w) (toFloat h) |> filled (rgb 10 10 10)

render : (Int, Int) -> Game -> Element
render (w, h) { s } = collage w h [ bg w h , ship s ]

time = Signal.map Time.inSeconds (Time.fps 35)

type alias Keys = { x: Int, y : Int }
type alias Input = { dt : Float, keys: Keys }
input : Signal Input
input = Signal.map2 Input time Keyboard.arrows

type alias Game = {
    t : Float,
    v : { x : Float, y : Float },
    s : { x : Float, y : Float }
}

update : Input -> Game -> Game
update { dt, keys } g = let
    t' = g.t + dt
    v' = { x = g.v.x + (toFloat keys.x) * dt, y = g.v.y + (toFloat keys.y) * dt }
    s' = { x = g.s.x + v'.x * 3 * dt, y = g.s.y + v'.y * 3 * dt }
  in { g | t <- t', v <- v', s <- s' }

defaultGame : Game
defaultGame = { t = 0, v = { x = 0, y = 0 }, s = { x = 0, y = 0 } }

gameState : Signal Game
gameState = Signal.foldp update defaultGame input

main : Signal Element
main = Signal.map2 render Window.dimensions gameState
