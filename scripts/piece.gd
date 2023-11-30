extends Node2D

signal turret_died
signal mineral_pick_up

func _on_LazerTurret_died():
	emit_signal("turret_died")

func _on_Mineral_collected():
	emit_signal("mineral_pick_up")

