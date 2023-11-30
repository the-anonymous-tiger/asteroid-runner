extends Node2D

signal turret_died
signal mineral_collected
signal spawning(spawn)
signal super_spawn(super)

const VELOCITY: = -2.0
# 1/2 size 328px
const A_HALF: = 328

var first_piece_scene_1 = preload("res://scenes/terrains/first_piece.tscn")
var second_piece_scene_1 = preload("res://scenes/terrains/second_piece.tscn")
var first_piece_scene_2 = preload("res://scenes/terrains/first_piece_2.tscn")
var second_piece_scene_2 = preload("res://scenes/terrains/second_piece_2.tscn")
var first_piece_scene_3 = preload("res://scenes/terrains/first_piece_3.tscn")
var second_piece_scene_3 = preload("res://scenes/terrains/second_piece_3.tscn")

var texture_width: = 0
var moving: = true
var first_updated: = false
var second_update: = false
var tutorial: = true
var first_piece = null
var second_piece = null

func _ready():
	var viewport_size = get_viewport().get_visible_rect().size
	texture_width = viewport_size.x
	
func _process(_delta):
	if moving:
		position.x += VELOCITY
		_attempt_reposition()

func stop_movement() -> void:
	moving = false
	
func _attempt_reposition() -> void:
	_generate_terrain()
		
	if position.x < -texture_width:
		position.x += 2 * texture_width
		_reset_updated()
		if tutorial:
			tutorial = false

func _generate_terrain() -> void:
	if position.x < -A_HALF and not first_updated:
		emit_signal("super_spawn", false)
		if is_instance_valid(first_piece):
			first_piece.queue_free()
		var new_fp = _get_first_piece(_get_random_number(1, 3))
		if new_fp:
			first_piece = _add_piece(new_fp)
		first_updated = true
		
	if position.x < -2 * A_HALF and not second_update:
		if is_instance_valid(second_piece):
			second_piece.queue_free()
		var new_sp = _get_second_piece(_get_random_number(1, 4))
		if new_sp:
			print("SP", new_sp)
			second_piece = _add_piece(new_sp)
		else:
			print("SUPER")
			emit_signal("super_spawn", true)
		second_update = true

func _get_first_piece(num: int):
	if num == 1:
		return first_piece_scene_1
	elif num == 2:
		return first_piece_scene_2
	elif num == 3:
		return first_piece_scene_3
		
func _get_second_piece(num: int):
	if num == 1:
		return second_piece_scene_1
	elif num == 2:
		return second_piece_scene_2
	elif num == 3:
		return second_piece_scene_3

func _reset_updated() -> void:
	first_updated = false
	second_update = false

func _on_lazer_turret_died():
	emit_signal("turret_died")

func _on_mineral_collected():
	emit_signal("mineral_collected")

func _add_piece(piece: Resource) -> Node:
	var piece_instance = piece.instance()
	piece_instance.connect("turret_died", self, "_on_lazer_turret_died")
	piece_instance.connect("mineral_pick_up", self, "_on_mineral_collected")
	self.add_child(piece_instance)
	return piece_instance

func _get_random_number(mininmum = 1, maximum = 3) -> int:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi_range(mininmum, maximum)
