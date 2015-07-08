module Update where

import Game exposing (Game, Coords, Shot, Player)
import Input exposing (Input)
import Random

updateAngle : Input -> Game -> Float
updateAngle { dt, torque } g = case torque of
            Input.CW -> g.player.angle - g.player.sideThrusterPower * dt
            Input.CCW -> g.player.angle + g.player.sideThrusterPower * dt
            Input.None -> g.player.angle

updateVel : Input -> Game -> Coords
updateVel { dt, thrust } g = let 
        vx = if thrust then g.player.vel.x + (cos g.player.angle) * g.player.rearThrusterPower * dt else g.player.vel.x
        vy = if thrust then g.player.vel.y + (sin g.player.angle) * g.player.rearThrusterPower * dt else g.player.vel.y
        vlen = sqrt (vx * vx + vy * vy)
        vscaled = min vlen g.player.maxVel
    in if vlen > 0 then { x = vx * vscaled / vlen, y = vy * vscaled / vlen } else { x = 0, y = 0 }

updatePos : Input -> Game -> Coords
updatePos { dt, window } g = let
    x' = g.player.pos.x + g.player.vel.x * dt
    y' = g.player.pos.y + g.player.vel.y * dt
    winW = toFloat <| fst window
    winH = toFloat <| snd window
    wx1 = winW / 2
    wy1 = winH / 2
    wx0 = negate wx1
    wy0 = negate wy1
    in {
        x = if x' > wx1 then x' - winW else if x' < wx0 then x' + winW else x',
        y = if y' > wy1 then y' - winH else if y' < wy0 then y' + winH else y'
    }

--canFire : Float -> Float -> List Shot -> Bool
--canFire fireRate t shots = let
--    lastShot = shots |> List.reverse |> List.head
--    in case lastShot of
--        Nothing -> True
--        Just s -> (t - s.firedAt) > (1 / fireRate)

makeShot : Player -> Float -> Float -> Shot
makeShot p wiggle t = let
    a = p.angle + wiggle
    v = {
        x = p.vel.x + p.shotSpeed * cos a,
        y = p.vel.y + p.shotSpeed * sin a
    } in {
        pos = p.pos,
        firedAt = t,
        vel = v,
        angle = a
    }

updateShot : Float -> Shot -> Shot
updateShot dt s = { s | pos <- { x = s.pos.x + s.vel.x * dt, y = s.pos.y + s.vel.y * dt } }

shotAlive : Game -> Shot -> Bool
shotAlive g s = (g.t - s.firedAt) <= g.player.shotAge

shotWiggleGen : Random.Generator Float
shotWiggleGen = Random.float -0.1 0.1

updateShots : Input -> Game -> Game
updateShots { firing, dt } ({ t, shots, player } as g) = let
    gen = Random.float (negate player.shotWiggle) player.shotWiggle
    updated = shots |> List.filter (shotAlive g) |> List.map (updateShot dt)
        in if not firing
            then { g | shots <- updated }
            else let (wiggle, wiggleSeed') = Random.generate gen g.shotWiggleSeed
                in { g | shots <- (makeShot player wiggle t) :: updated,
                         shotWiggleSeed <- wiggleSeed' }

updateWindow : Input -> Game -> Game
updateWindow { window } g = { g | window <- {
        x = toFloat (fst window),
        y = toFloat (snd window)
    } }

updateTime : Input -> Game -> Game
updateTime { dt } ({ t } as g) = { g | t <- t + dt }

updatePlayer : Input -> Game -> Game
updatePlayer i ({ player } as g) =
    { g | player <- { player | pos <- updatePos i g,
                               vel <- updateVel i g,
                               angle <- updateAngle i g } }

update : Input -> Game -> Game
update i g = g |> (updateWindow i) |> (updateTime i) |> (updatePlayer i) |> (updateShots i)
