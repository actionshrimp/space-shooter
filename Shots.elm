module Shots where

import Random
import Types exposing (..)
import Vec exposing (windowBounded)

defaultShots = {
    rSeed = Random.initialSeed 0,
    list = []
    }

canFire : Game -> Bool
canFire g = let lastShot = g.shots.list |> List.head in
    case lastShot of
      Nothing -> True
      Just s -> (1.0 / g.player.shotRate) <= (g.t - s.firedAt)

makeShot : (Float, Float) -> Game -> Game
makeShot (x0, y0) g = let
    gen = Random.float (-g.player.shotWiggle) g.player.shotWiggle
    (wiggle, wiggleSeed') = Random.generate gen g.shots.rSeed
    p = g.player
    a = p.angle + wiggle
    v = {
        x = p.vel.x + p.shotSpeed * cos a,
        y = p.vel.y + p.shotSpeed * sin a
    }
    shot = {
        pos = {
            x = p.pos.x + x0 * cos p.angle - y0 * sin p.angle,
            y = p.pos.y + x0 * sin p.angle + y0 * cos p.angle
        },
        firedAt = g.t,
        vel = v,
        angle = a
    } in { g | shots <- { rSeed = wiggleSeed',
                          list = shot :: g.shots.list } }

addNewShots : Input -> Game -> Game
addNewShots { firing } g = case (firing, canFire g) of
    (True, True) -> List.foldl makeShot g [(0, -10), (0, 10)]
    _ -> g

updateShot : Input -> Shot -> Shot
updateShot { dt, window } s = { s | pos <- {
    x = s.pos.x + s.vel.x * dt, y = s.pos.y + s.vel.y * dt } }

shotAlive : Game -> Shot -> Bool
shotAlive g s = (g.t - s.firedAt) <= g.player.shotAge
    && s.pos.x <= g.window.x / 2 && s.pos.x >= -g.window.x / 2
    && s.pos.y <= g.window.y / 2 && s.pos.y >= -g.window.y / 2

updateShots : Input -> Game -> Game
updateShots i ({ shots } as g) = {
    g | shots <- {
        shots | list <- g.shots.list |> List.filter (shotAlive g) |> List.map (updateShot i)
    } }
