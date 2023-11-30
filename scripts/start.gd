extends Control

func _ready() -> void:
	if OS.has_feature('JavaScript'):
		var high_score = JavaScript.eval("Number(localStorage.getItem(\"highScore\"));")
		
		if high_score:
			$Panel/QuickPlayButton.show()

func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://scenes/dialog.tscn")


func _on_QuickPlayButton_pressed() -> void:
	get_tree().change_scene("res://scenes/game.tscn")
	
