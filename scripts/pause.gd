extends Control

signal resume

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func set_state(new_score: int, lives: int):
	$Panel/Score.text = "SCORE: " + str(new_score)
	$Panel/Life.text = str(lives)

func _on_continue_button_pressed():
	emit_signal("resume")

