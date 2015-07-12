module Render where

import Types exposing (..)

import Graphics.Collage exposing (..)
import Graphics.Element exposing (Element, leftAligned, color, width, flow, down, topLeft, container)
import Color exposing (..)
import Text

ship : Player -> Form
ship p = group [
        oval 16 8 |> filled (rgb 200 0 0) |> move (0, -5),
        oval 16 8 |> filled (rgb 200 0 0) |> move (0, 5),
        rect 4 24 |> filled (rgb 200 0 0) |> move (-2, 0),
        rect 14 4 |> filled (rgb 200 0 0) |> move (4, 0),
        ngon 3 6 |> filled (rgb 200 0 0) |> move (12, 0)
    ] |> move (p.pos.x, p.pos.y) |> rotate p.angle

shot : Shot -> Form
shot s = ngon 3 2 |> filled white |> move (s.pos.x, s.pos.y)

asteroid : Asteroid -> Form
asteroid a = ngon 5 a.radius |> filled white |> move (a.pos.x, a.pos.y) |> rotate a.angle

bg : Game -> Form
bg g = rect g.window.x g.window.y |> filled (rgb 10 10 10)

toGameInfoEl : String -> Element
toGameInfoEl x = Text.fromString x
    |> Text.color white |> Text.height 12
    |> leftAligned

gameInfo : Game -> Form
gameInfo g = List.map toGameInfoEl [
    "window: " ++ (toString g.window),
    "t: " ++ (toString g.t),
    "player.pos: " ++ (toString g.player.pos),
    "player.vel: " ++ (toString g.player.vel),
    "player.angle: " ++ (toString g.player.angle),
    "length shots: " ++ (toString <| List.length g.shots.list)
    ]
    |> flow down
    |> container (round g.window.x) (round g.window.y) topLeft
    |> toForm |> move (10, -10) 

render : Game -> Element
render g = collage (round g.window.x) (round g.window.y) (
        [bg g]
        ++ List.map shot g.shots.list
        ++ [ship g.player , gameInfo g]
        ++ List.map asteroid g.asteroids.list
    )
