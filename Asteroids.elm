module Asteroids where

import Random
import Types exposing (..)
import Vec exposing (genVec, windowBounded)

genAsteroid : Float -> Float -> Random.Generator Asteroid
genAsteroid w h = Random.customGenerator <| \s0 ->
    let (radMul, s1) = Random.generate (Random.float 1 3) s0
        (pos, s2) = Random.generate (genVec (-w/2) (w/2) (-h/2) (h/2)) s1
        (vel, s3) = Random.generate (genVec -50 50 -50 50) s2
        (angVel, s4) = Random.generate (Random.float -1 1) s3
        (health, s5) = Random.generate (Random.float 10 20) s4
        (rank, s6) = Random.generate (Random.int 2 5) s5
        (angle, s7) = Random.generate (Random.float 0 3) s6
    in ({
        pos = pos,
        vel = vel,
        angle = angle,
        angularVel = angVel,
        radius = radMul * (toFloat rank) * 5,
        health = health,
        rank = rank
    }, s7)

defaultAsteroids : Asteroids
defaultAsteroids =
    let count = 10
        s = Random.initialSeed 0
        (list, s') = Random.generate (Random.list count (genAsteroid 500 500)) s
    in {
        list = list,
        rSeed = s'
    }

updateAsteroid : Input -> Asteroid -> Asteroid
updateAsteroid { dt, window } a =
    let pos' = {
        x = a.pos.x + a.vel.x * dt,
        y = a.pos.y + a.vel.y * dt }
    in { a | pos <- windowBounded window pos',
             angle <- a.angle + a.angularVel * dt }

updateAsteroids : Input -> Game -> Game
updateAsteroids i ({ asteroids } as g) = {
    g | asteroids <- {
        asteroids | list <- List.map (updateAsteroid i) g.asteroids.list } }
