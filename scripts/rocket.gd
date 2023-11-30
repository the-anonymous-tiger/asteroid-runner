extends Area2D

var is_small: = false

export var speed = 400

onready var visible_notifier = $VisibleNotifier
onready var explosion = $Explosion
onready var reactor = $Reactor

func _physics_process(delta):
	global_position.x += speed*delta

func _on_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area.small_lives > 0 and is_small:
		area.damage()
		_play_explosion(-250)
	elif not area.is_exploding:
		queue_free()
		area.die()

func _on_body_entered(body):
	if body is TileMap:
		_play_explosion(0)

func _play_explosion(new_speed: int) -> void:
	$Sprite.hide()
	$Reactor.hide()
	speed = new_speed
	explosion.visible = true
	explosion.play("explosion")

func _on_explosion_animation_finished():
	queue_free()
