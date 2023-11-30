extends Area2D

class_name Turret

signal died

const MAX_ANGLE: = -30
const MIN_ANGLE: = -150
const ROTATION_SPEED: = 50

onready var turret = $Turret

# Basic state
var scanning: = false
var scanning_right: = false
var small_lives: = 0
var is_exploding: = false

func scan(delta) -> void:
	if scanning_right:
		if turret.rotation_degrees < MAX_ANGLE:
			turret.rotation_degrees += ROTATION_SPEED * delta
		else:
			scanning_right = false
	
	if not scanning_right:
		if turret.rotation_degrees > MIN_ANGLE:
			turret.rotation_degrees -= ROTATION_SPEED * delta
		else:
			scanning_right = true
