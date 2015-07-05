module Render where

import Game exposing (Game)

import Graphics.Collage exposing (collage, toForm, rect, filled, Form, move)
import Graphics.Element exposing (Element, show)
import Color exposing (..)

ship : Game -> Form
ship g = rect 10 10 |> filled (rgb 200 0 0) |> move (g.s.x, g.s.y)

bg : Game -> Form
bg g = rect g.window.x g.window.y |> filled (rgb 10 10 10)

render : Game -> Element
render g = collage (round g.window.x) (round g.window.y) [ bg g , ship g ]
