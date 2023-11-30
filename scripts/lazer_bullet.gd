extends Area2D

export var speed: = 100
export var inverted: = false

var dying: = false

func _process(delta):
	if not dying:
		_move(delta)

func die() -> void:
	dying = true
	$Sprite.hide()
	$AnimatedSprite.show()
	$AnimatedSprite.play("explode")
	
func _move(delta) -> void:
	if not inverted:
		global_position.x += speed*delta*cos(rotation)
		global_position.y += speed*delta*sin(rotation)
	else:
		global_position.x -= speed*delta*cos(rotation)
		global_position.y -= speed*delta*sin(rotation)

func _on_visible_notifier_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body is TileMap:
		die()
	
	if body is KinematicBody2D:
		body.take_damage()
		die()
		
func _on_animated_sprite_2d_animation_finished():
	queue_free()
