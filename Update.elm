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

canFire : Game -> Bool
canFire g = let lastShot = g.shots |> List.head in
    case lastShot of
      Nothing -> True
      Just s -> (1.0 / g.player.shotRate) <= (g.t - s.firedAt)

makeShot : (Float, Float) -> Game -> Game
makeShot (x0, y0) g = let
    gen = Random.float (-g.player.shotWiggle) g.player.shotWiggle
    (wiggle, wiggleSeed') = Random.generate gen g.shotWiggleSeed
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
    } in
    { g | shotWiggleSeed <- wiggleSeed',
          shots <- shot :: g.shots }

addNewShots : Input -> Game -> Game
addNewShots { firing } g = case (firing, canFire g) of
    (True, True) -> List.foldl makeShot g [(0, -10), (0, 10)]
    _ -> g

updateShot : Float -> Shot -> Shot
updateShot dt s = { s | pos <- { x = s.pos.x + s.vel.x * dt, y = s.pos.y + s.vel.y * dt } }

shotAlive : Game -> Shot -> Bool
shotAlive g s = (g.t - s.firedAt) <= g.player.shotAge

updateShots : Input -> Game -> Game
updateShots { dt } g = { g | shots <- g.shots |> List.filter (shotAlive g) |> List.map (updateShot dt) }
--    updated = 
--        in case (firing, canFire g) of
--            (True, True) -> let (wiggle, wiggleSeed') = Random.generate gen g.shotWiggleSeed
--                            in { g | shots <- (makeShot player wiggle t) ++ updated
--                                   , shotWiggleSeed <- wiggleSeed' }
--            _ -> { g | shots <- updated }

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
update i g = g |> (updateWindow i) |> (updateTime i) |> (updatePlayer i) |> (updateShots i) |> (addNewShots i)
