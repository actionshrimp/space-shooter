module Player where

import Types exposing (..)
import Vec exposing (windowBounded)

defaultPlayer : Player
defaultPlayer = {
        rearThrusterPower = 2500,
        sideThrusterPower = 10,
        stopFactor = 10,
        maxVel = 1000,
        shotSpeed = 1500,
        shotAge = 1,
        shotWiggle = 0.02,
        shotRate = 10,
        pos = { x = 0, y = 0 },
        vel = { x = 0, y = 0 },
        angle = 0
    }

updateAngle : Input -> Game -> Float
updateAngle { dt, torque } g = case torque of
            CW -> g.player.angle - g.player.sideThrusterPower * dt
            CCW -> g.player.angle + g.player.sideThrusterPower * dt
            None -> g.player.angle

updateVel : Input -> Game -> Vec
updateVel { dt, thrust, stop } g =
    if stop then {
        x = g.player.vel.x - g.player.vel.x * g.player.stopFactor * dt,
        y = g.player.vel.y - g.player.vel.y * g.player.stopFactor * dt
    } else
    let vx = if thrust then g.player.vel.x + (cos g.player.angle) * g.player.rearThrusterPower * dt else g.player.vel.x
        vy = if thrust then g.player.vel.y + (sin g.player.angle) * g.player.rearThrusterPower * dt else g.player.vel.y
        vlen = sqrt (vx * vx + vy * vy)
        vscaled = min vlen g.player.maxVel
    in if vlen > 0 then { x = vx * vscaled / vlen, y = vy * vscaled / vlen } else { x = 0, y = 0 }

updatePos : Input -> Game -> Vec
updatePos { dt, window } g = let
    p = {
        x = g.player.pos.x + g.player.vel.x * dt,
        y = g.player.pos.y + g.player.vel.y * dt
    } in windowBounded window p

updatePlayer : Input -> Game -> Game
updatePlayer i ({ player } as g) =
    { g | player <- { player | pos <- updatePos i g,
                               vel <- updateVel i g,
                               angle <- updateAngle i g } }
