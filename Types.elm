module Types where

import Random

type alias Vec = { x : Float, y : Float }

type alias Player = {
    rearThrusterPower : Float,
    sideThrusterPower : Float,
    stopFactor : Float,
    maxVel : Float,
    shotSpeed: Float,
    shotAge: Float,
    shotWiggle: Float,
    shotRate: Float,
    pos : Vec,
    vel : Vec,
    angle : Float
}

type alias Shot = {
    pos : Vec,
    vel : Vec,
    firedAt: Float,
    angle: Float
}

type alias Shots = {
    list : List Shot,
    rSeed : Random.Seed
}

type alias Asteroid = {
    pos : Vec,
    vel : Vec,
    angle : Float,
    angularVel : Float,
    radius : Float,
    health : Float,
    rank : Int,
    sides : Int,
    colliding : Bool,
    vel' : Vec,
    colNorm : Vec
    }

type alias Asteroids = {
    maxSpeed : Float,
    list : List Asteroid,
    rSeed : Random.Seed
    }

type Torque = None | CW | CCW

type alias Input = {
    window : (Int, Int),
    dt : Float,
    thrust : Bool,
    torque : Torque,
    stop : Bool,
    firing : Bool
}

type alias Game = {
    window : Vec,
    t : Float,
    player : Player,
    shots : Shots,
    asteroids : Asteroids
}
