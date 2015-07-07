module Update where

import Game exposing (Game)
import Input exposing (Input)

accel = { x = 50, y = 50 }

update : Input -> Game -> Game
update { dt, thrust, torque, window } g = let
    window' = { x = toFloat (fst window), y = toFloat (snd window) }
    t' = g.t + dt
    a' = case torque of
            Input.CW -> g.player.angle - g.player.ship.side_thruster_power * dt
            Input.CCW -> g.player.angle + g.player.ship.side_thruster_power * dt
            Input.None -> g.player.angle
    vx = if thrust then g.player.vel.x + (a' * (cos g.player.angle)) * g.player.ship.rear_thruster_power * dt else g.player.vel.x
    vy = if thrust then g.player.vel.y - (a' * (sin g.player.angle)) * g.player.ship.rear_thruster_power * dt else g.player.vel.y
    sx = g.player.pos.x + g.player.vel.x
    sy = g.player.pos.y + g.player.vel.y
  in { g | t <- t', window <- window', player <- {
        ship = g.player.ship,
        pos = { x = sx, y = sy },
        vel = { x = vx, y = vy },
        angle = a'
      }}
