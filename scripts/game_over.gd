extends Control

func set_score(new_score):
	var high_score
	if OS.has_feature('JavaScript'):
		high_score = JavaScript.eval("Number(localStorage.getItem(\"highScore\"));")
		if new_score > high_score:
			var expression = "localStorage.setItem(\"highScore\", %s);"
			var actual_expression = expression % new_score
			JavaScript.eval(actual_expression)
			high_score = new_score
	
	if not high_score:
		high_score = new_score

	$Panel/Score2.text = "HIGH SCORE: " + str(high_score)
	$Panel/Score.text = "SCORE: " + str(new_score)

func _on_retry_button_pressed():
	get_tree().reload_current_scene()
