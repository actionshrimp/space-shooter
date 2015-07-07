module Render where

import Game exposing (Game, Coords)

import Graphics.Collage exposing (collage, toForm, rect, polygon, filled, Form, move, rotate)
import Graphics.Element exposing (Element, leftAligned, color, width, flow, down, topLeft, container)
import Color exposing (..)
import Text

ship : Game -> Form
ship g = polygon [(-5, 5), (10, 0), (-5, -5)] |> filled (rgb 200 0 0)
    |> move (g.player.pos.x, g.player.pos.y) |> rotate g.player.angle

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
    "player.angle: " ++ (toString g.player.angle)
    ]
    |> flow down
    |> container (round g.window.x) (round g.window.y) topLeft
    |> toForm |> move (10, -10) 

render : Game -> Element
render g = collage (round g.window.x) (round g.window.y) [
    bg g, ship g, gameInfo g]
