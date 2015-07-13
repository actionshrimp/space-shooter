module Asteroids where

import Random
import Types exposing (..)
import Vec
import Vec exposing (genVec, windowBounded)

genAsteroid : Float -> Float -> Random.Generator Asteroid
genAsteroid w h = Random.customGenerator <| \s0 ->
    let (radMul, s1) = Random.generate (Random.float 1 3) s0
        (pos, s2) = Random.generate (genVec -w w -h h) s1
        (vel, s3) = Random.generate (genVec -50 50 -50 50) s2
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
        colliding = False,
        vel' = vel,
        colNorm = Vec.zero
    }, s8)

defaultAsteroids : Asteroids
defaultAsteroids =
    let count = 8
        s = Random.initialSeed 0
        (list, s') = Random.generate (Random.list count (genAsteroid 500 500)) s
    in {
        maxSpeed = 150,
        list = list,
        rSeed = s'
    }

colliding : Asteroid -> Asteroid -> Bool
colliding a b = Vec.mag (Vec.sub a.pos b.pos) < (a.radius + b.radius)

collisionNormal : Asteroid -> Asteroid -> Vec
collisionNormal a x =
    let normal = Vec.sub x.pos a.pos
        dot = Vec.dot a.vel normal
        dir = if dot >= 0 then 1 else -1
    in Vec.mul dir normal

collisionNormals : List Asteroid -> Asteroid -> Vec
collisionNormals cs a =
    let normList = List.map (collisionNormal a) cs
        in Vec.norm <| List.foldl Vec.add Vec.zero normList

updateAsteroid : Input -> Game -> Asteroid -> Asteroid
updateAsteroid { dt, window } { asteroids } a =
    let intR = round a.radius
        winWithDiameter = (fst window + 2*intR, snd window + 2*intR)
        others = List.filter ((/=) a) asteroids.list
        collisions = List.filter (colliding a) others
        hasCollision = not <| List.isEmpty collisions
        v' = if not hasCollision then a.vel else
                let normal = collisionNormals collisions a
                in Vec.reflect a.vel normal
        v'' = Vec.magBounded asteroids.maxSpeed v'
        v''' = if hasCollision then Vec.mul 4 v'' else v''
        pos' = { x = a.pos.x + v'''.x * dt, y = a.pos.y + v'''.y * dt }
    in { a | pos <- windowBounded winWithDiameter pos'
           , angle <- a.angle + a.angularVel * dt
           , colliding <- hasCollision
           , vel <- v''
           , vel' <- v''
           , colNorm <- if hasCollision then collisionNormals collisions a else Vec.zero
            }

updateAsteroids : Input -> Game -> Game
updateAsteroids i ({ asteroids } as g) = {
    g | asteroids <- {
        asteroids | list <- List.map (updateAsteroid i g) g.asteroids.list } }
