extends Area2D

signal collected

func _on_body_entered(body):
	if body is KinematicBody2D:
		emit_signal("collected")
		queue_free()
