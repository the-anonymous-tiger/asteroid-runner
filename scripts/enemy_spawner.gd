extends Node2D

signal enemy_spawned(enemy_instance)
signal path_enemy_spawned(path_enemy_instance)

const super_time: = 0.6
const normal_time: = 2

var enemy_scene = preload("res://scenes/enemy.tscn")
var path_enemy_scene = preload("res://scenes/path_enemy.tscn")

onready var spawn_positions = $SpawnPoints

export var spawning: = true

func super_spawn(super: bool) -> void:
	if super:
		$Timer.wait_time = super_time
	else:
		$Timer.wait_time = normal_time

func _on_timer_timeout():
	if spawning:
		spawn_enemy()

func spawn_enemy():
	var rng = RandomNumberGenerator.new()
	var spawn_positions_array = spawn_positions.get_children()
	rng.randomize()
	var random_spawn_position = spawn_positions_array[rng.randi_range(0, spawn_positions_array.size() - 1)]
	
	var enemy_instance = enemy_scene.instance()
	enemy_instance.global_position = random_spawn_position.global_position
	emit_signal("enemy_spawned", enemy_instance)

func _on_path_enemy_timer_timeout():
	if spawning:
		spawn_path_enemy()

func spawn_path_enemy():
	var path_enemy_instance = path_enemy_scene.instance()
	emit_signal("path_enemy_spawned", path_enemy_instance)

func stop_spawn() -> void:
	queue_free()

