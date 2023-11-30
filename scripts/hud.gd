extends Control

signal pause_click

onready var score = $Score
onready var lives_left = $LivesLeft

func set_score_label(new_score):
	score.text = "SCORE: " + str(new_score)

func set_lives(amount):
	lives_left.text = str(amount)


func _on_texture_button_pressed():
	emit_signal("pause_click")
