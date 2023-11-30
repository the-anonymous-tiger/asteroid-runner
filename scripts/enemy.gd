extends Area2D

signal died

onready var animation = $AnimatedSprite
onready var reactor = $Reactor

export var speed = 200

var is_exploding: = false
var small_lives: = 1

func _physics_process(delta):
	global_position.x += -speed * delta

func die(emit = true) -> void:
	reactor.hide()
	if emit and not is_exploding:
		emit_signal("died")
	is_exploding = true
	animation.play("explode")

func damage() -> void:
	small_lives -= 1
	animation.play("damage")

func _on_body_entered(body) -> void:
	var emit: = false
	if body is KinematicBody2D and not is_exploding:
		body.take_damage()
		emit = true
	die(emit)


func _on_animated_sprite_2d_animation_finished():
	if is_exploding:
		queue_free()
