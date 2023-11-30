extends KinematicBody2D

signal took_damage
signal pause
signal nose_touch(touching)

var speed = 300
var is_small: = false
var hits: = 0
var velocity = Vector2()

var rocket_scene = preload("res://scenes/rocket.tscn")

onready var fire_container = $FireContainer
onready var shot_sound = $ShotSound
onready var animation = $AnimatedSprite
onready var i_frame = $IFrame
onready var reactor = $Reactor

func _process(_delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(_delta):
	velocity = Vector2(0,0)
	
	if Input.is_action_just_pressed("pause"):
		emit_signal("pause")
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	if Input.is_action_pressed("move_up"):
		velocity.y = -speed
	if Input.is_action_pressed("move_down"):
		velocity.y = speed
	if Input.is_action_just_pressed("change_scale"):
		if is_small:
			set_scale(Vector2(1, 1))
			is_small = false
		else:
			set_scale(Vector2(0.5, 0.5))
			is_small = true
	
	move_and_slide(velocity)
	
	var screen_size = get_viewport_rect().size
	
	var temp_position = Vector2()
	temp_position.x = clamp(global_position.x, 0, screen_size.x)
	temp_position.y = clamp(global_position.y, 0, screen_size.y)
	global_position = temp_position

func shoot():
	var rocket_instance = rocket_scene.instance()
	fire_container.add_child(rocket_instance)
	rocket_instance.global_position = global_position
	rocket_instance.global_position.x += 20
	if is_small:
		rocket_instance.set_scale(Vector2(0.5, 0.5))
		rocket_instance.is_small = true
	shot_sound.play()

func take_damage():
	if i_frame.is_stopped():
		if hits < 2:
			animation.play("hit") 
		hits +=1
		emit_signal("took_damage")
		i_frame.start()
	
func explode():
	reactor.hide()
	animation.play("exploding")

func die():
	queue_free()

func _on_i_frame_timeout():
	animation.play("default")

func _on_nose_area_body_entered(body):
	if body is TileMap:
		emit_signal("nose_touch", true)

func _on_nose_area_body_exited(body):
	if body is TileMap:
		emit_signal("nose_touch", false)

