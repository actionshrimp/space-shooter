module Render where

import Game exposing (Game)

import Graphics.Collage exposing (collage, toForm, rect, ngon, filled, Form, move, rotate)
import Graphics.Element exposing (Element, leftAligned, color, width)
import Color exposing (..)
import Text

ship : Game -> Form
ship g = ngon 3 8 |> filled (rgb 200 0 0) |> move (g.player.pos.x, g.player.pos.y) |> rotate g.player.angle

bg : Game -> Form
bg g = rect g.window.x g.window.y |> filled (rgb 10 10 10)

gameInfo : Game -> Form
gameInfo g = toForm (toString g |> Text.fromString |> Text.color white |> leftAligned) |> move (0, 300)

render : Game -> Element
render g = collage (round g.window.x) (round g.window.y) [ bg g , ship g, gameInfo g ]
