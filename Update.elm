module Update where

import Game exposing (Game)
import Input exposing (Input)

update : Input -> Game -> Game
update { dt, thrust, torque, window } g = let
    window' = { x = toFloat (fst window), y = toFloat (snd window) }
    t' = g.t + dt
    a' = case torque of
            Input.CW -> g.player.angle - g.player.ship.side_thruster_power * dt
            Input.CCW -> g.player.angle + g.player.ship.side_thruster_power * dt
            Input.None -> g.player.angle
    vx = if thrust then g.player.vel.x + (cos g.player.angle) * g.player.ship.rear_thruster_power * dt else g.player.vel.x
    vy = if thrust then g.player.vel.y + (sin g.player.angle) * g.player.ship.rear_thruster_power * dt else g.player.vel.y
    sx = g.player.pos.x + vx * dt
    sy = g.player.pos.y + vy * dt
    vlen = sqrt (vx * vx + vy * vy)
    vscaled = min vlen g.player.ship.max_vel
    vel' = if vlen > 0 then { x = vx * vscaled / vlen, y = vy * vscaled / vlen } else { x = 0, y = 0 }
  in { g | t <- t', window <- window', player <- {
        ship = g.player.ship,
        pos = { x = sx, y = sy },
        vel = vel',
        angle = a'
      }}
