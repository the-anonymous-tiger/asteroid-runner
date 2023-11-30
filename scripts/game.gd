extends Node2D

const ENEMY_HIT_SCORE = 100
const TURRET_HIT_SCORE = 50
const COLLECTED_SCORE = 200

var lives: = 3
var score: = 0
var player_in_deathzone: = false
var player_nose_touching_tiles: = false
var crushing: = false
var super_spawn: = false

onready var player = $Player
onready var hud = $UI/HUD
onready var ui = $UI
onready var player_hit_sound = $PlayerHitSound
onready var explosion_sound = $ExplosionSound
onready var collected_sound = $CollectedSound
onready var terrain = $Terrain
onready var enemy_spawner = $EnemySpawner
onready var pause = $UI/Pause

var game_over_scene = preload("res://scenes/game_over.tscn")

func _ready():
	hud.set_score_label(score)
	hud.set_lives(lives)

func _on_death_zone_area_entered(area):
		area.queue_free()

func _on_player_took_damage():
	player_hit_sound.play()
	lives -= 1
	hud.set_lives(lives)
	if (lives == 0):
		_kill_player()
		
func _kill_player() -> void:
	player.explode()
	explosion_sound.play()
	enemy_spawner.stop_spawn()
	
	yield(get_tree().create_timer(1), "timeout")
	
	player.die()
	
	yield(get_tree().create_timer(1), "timeout")
	
	terrain.stop_movement()
	var game_over = game_over_scene.instance()
	game_over.set_score(score)
	game_over.rect_global_position = Vector2(340, 170)
	ui.add_child(game_over)
	
func _crush_player() -> void:
	if not crushing:
		crushing = true
		lives = 0
		hud.set_lives(lives)
		_kill_player()
		
func _on_enemy_spawner_enemy_spawned(enemy_instance):
	enemy_instance.connect("died", self, "_on_enemy_died")
	add_child(enemy_instance)

func _on_enemy_died():
	if not player_hit_sound.playing:
		explosion_sound.play()
	score += ENEMY_HIT_SCORE
	hud.set_score_label(score)

func _on_enemy_spawner_path_enemy_spawned(path_enemy_instance):
	add_child(path_enemy_instance)
	path_enemy_instance.enemy.connect("died", self, "_on_enemy_died")

func _on_player_pause():
	get_tree().paused = true
	pause.set_state(score, lives)
	pause.show()

func _on_pause_resume():
	get_tree().paused = false
	pause.hide()	

func _on_hud_pause_click():
	_on_player_pause()

func _on_death_zone_body_entered(body):
	if body is KinematicBody2D:
		player_in_deathzone = true
		
		if player_nose_touching_tiles:
			_crush_player()

func _on_death_zone_body_exited(body):
	if body is KinematicBody2D:
		player_in_deathzone = false

func _on_player_nose_touch(touching: bool):
	if touching and player_in_deathzone:
		_crush_player()
	else:
		player_nose_touching_tiles = touching

func _on_terrain_turret_died():
	explosion_sound.play()
	score += TURRET_HIT_SCORE
	hud.set_score_label(score)

func _on_terrain_mineral_collected():
	score += COLLECTED_SCORE
	hud.set_score_label(score)
	collected_sound.play()

func _on_terrain_spawning(spawn):
	enemy_spawner.spawning = spawn


func _on_Terrain_super_spawn(super):
	if is_instance_valid(enemy_spawner):
		enemy_spawner.super_spawn(super)
