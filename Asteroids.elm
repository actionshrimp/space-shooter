module Asteroids where

import Random
import Types exposing (..)
import Vec
import Vec exposing (genVec, windowBounded)

genAsteroid : Float -> Float -> Random.Generator Asteroid
genAsteroid w h = Random.customGenerator <| \s0 ->
    let (radMul, s1) = Random.generate (Random.float 1 3) s0
        (pos, s2) = Random.generate (genVec -w w -h h) s1
        (vel, s3) = Random.generate (genVec -5 5 -5 5) s2
        (angVel, s4) = Random.generate (Random.float -1 1) s3
        (health, s5) = Random.generate (Random.float 10 20) s4
        (rank, s6) = Random.generate (Random.int 2 5) s5
        (angle, s7) = Random.generate (Random.float 0 3) s6
        (sides, s8) = Random.generate (Random.int 5 7) s7
    in ({
        pos = pos,
        vel = vel,
        angle = angle,
        angularVel = angVel,
        radius = radMul * (toFloat rank) * 10,
        health = health,
        rank = rank,
        sides = sides,
        colliding = False
    }, s8)

defaultAsteroids : Asteroids
defaultAsteroids =
    let count = 10
        s = Random.initialSeed 0
        (list, s') = Random.generate (Random.list count (genAsteroid 500 500)) s
    in {
        list = list,
        rSeed = s'
    }

colliding : Asteroid -> Asteroid -> Bool
colliding a b = Vec.mag (Vec.sub a.pos b.pos) < (a.radius + b.radius)

collisionNormal : List Asteroid -> Asteroid -> Vec
collisionNormal cs a =
    let normList = List.map (\x -> Vec.sub a.pos x.pos) cs
        in List.foldl Vec.add Vec.zero normList

updateAsteroid : Input -> Game -> Asteroid -> Asteroid
updateAsteroid { dt, window } { asteroids } a =
    let intR = round a.radius
        winWithDiameter = (fst window + 2*intR, snd window + 2*intR)
        others = List.filter ((/=) a) asteroids.list
        collisions = List.filter (colliding a) others
        hasCollision = not <| List.isEmpty collisions
        v' = if not hasCollision then a.vel else
                let normal = collisionNormal collisions a
                in Vec.reflect a.vel (Vec.norm normal)
        dx = if not hasCollision
                then { x = v'.x * dt, y = v'.y * dt }
                else { x = 5 * v'.x * dt, y = v'.y * dt }
        pos' = { x = a.pos.x + dx.x, y = a.pos.y + dx.y }
    in { a | pos <- windowBounded winWithDiameter pos'
           , angle <- a.angle + a.angularVel * dt
           , colliding <- hasCollision
           , vel <- v'
            }

updateAsteroids : Input -> Game -> Game
updateAsteroids i ({ asteroids } as g) = {
    g | asteroids <- {
        asteroids | list <- List.map (updateAsteroid i g) g.asteroids.list } }
