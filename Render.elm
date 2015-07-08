module Render where

import Game exposing (Game, Coords, Player, Shot)

import Graphics.Collage exposing (collage, toForm, rect, polygon, filled, Form, move, rotate, ngon)
import Graphics.Element exposing (Element, leftAligned, color, width, flow, down, topLeft, container)
import Color exposing (..)
import Text

ship : Player -> Form
ship p = polygon [(-5, 5), (10, 0), (-5, -5)] |> filled (rgb 200 0 0)
    |> move (p.pos.x, p.pos.y) |> rotate p.angle

shot : Shot -> Form
shot s = ngon 3 2 |> filled white |> move (s.pos.x, s.pos.y)

bg : Game -> Form
bg g = rect g.window.x g.window.y |> filled (rgb 10 10 10)

toGameInfoEl : String -> Element
toGameInfoEl x = Text.fromString x
    |> Text.color white |> Text.height 12
    |> leftAligned

gameInfo : Game -> Form
gameInfo g = List.map toGameInfoEl [
    "window: " ++ (toString g.window),
    "player.pos: " ++ (toString g.player.pos),
    "player.vel: " ++ (toString g.player.vel),
    "player.angle: " ++ (toString g.player.angle),
    "length shots: " ++ (toString <| List.length g.shots)
    ]
    |> flow down
    |> container (round g.window.x) (round g.window.y) topLeft
    |> toForm |> move (10, -10) 

render : Game -> Element
render g = collage (round g.window.x) (round g.window.y) ([
    bg g
    , ship g.player
    , gameInfo g
    ] ++ List.map shot g.shots)
