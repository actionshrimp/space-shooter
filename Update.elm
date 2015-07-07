module Update where

import Game exposing (Game, Coords)
import Input exposing (Input)

updatedAngle : Input -> Game -> Float
updatedAngle { dt, torque } g = case torque of
            Input.CW -> g.player.angle - g.player.ship.side_thruster_power * dt
            Input.CCW -> g.player.angle + g.player.ship.side_thruster_power * dt
            Input.None -> g.player.angle

updatedVel : Input -> Game -> Coords
updatedVel { dt, thrust } g = let 
        vx = if thrust then g.player.vel.x + (cos g.player.angle) * g.player.ship.rear_thruster_power * dt else g.player.vel.x
        vy = if thrust then g.player.vel.y + (sin g.player.angle) * g.player.ship.rear_thruster_power * dt else g.player.vel.y
        vlen = sqrt (vx * vx + vy * vy)
        vscaled = min vlen g.player.ship.max_vel
    in if vlen > 0 then { x = vx * vscaled / vlen, y = vy * vscaled / vlen } else { x = 0, y = 0 }

updatedPos : Input -> Game -> Coords
updatedPos { dt } g = {
        x = g.player.pos.x + g.player.vel.x * dt,
        y = g.player.pos.y + g.player.vel.y * dt
    }

update : Input -> Game -> Game
update i g = {
    g |
        window <- { x = toFloat (fst i.window), y = toFloat (snd i.window) },
        t <- g.t + i.dt,
        player <- {
            ship = g.player.ship,
            pos = updatedPos i g,
            vel = updatedVel i g,
            angle = updatedAngle i g
            }
        }
