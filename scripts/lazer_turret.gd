extends Turret

export var inverted: = false

onready var fire_container = $Turret/FireContainer
onready var fire_debounce = $Turret/FireDebounce
onready var shooter = $Shooter

var lazer_scene = preload("res://scenes/turrets/lazer_bullet.tscn")

# Firing state (individual state)
var firing: = false

func _process(delta):
	if scanning:
		scan(delta)
	if firing:
		fire()
	
func fire() -> void:
	if fire_debounce.is_stopped():
		var lazer_instance = lazer_scene.instance()
		shooter.add_child(lazer_instance)
		lazer_instance.inverted = inverted
		lazer_instance.rotation_degrees = turret.rotation_degrees
		lazer_instance.global_position = fire_container.global_position
		fire_debounce.start()

func die() -> void:
	emit_signal("died")
	firing = false
	queue_free()

func _on_visible_notifier_screen_entered():
	scanning = true
	firing = true
	show()

func _on_visible_notifier_screen_exited():
	scanning = false
	firing = false
	hide()

func _on_LazerTurret_body_entered(body):
	if body is KinematicBody2D:
		body.take_damage()
