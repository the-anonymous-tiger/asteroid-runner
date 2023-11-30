extends Path2D

onready var pathfollow = $PathFollow2D
onready var enemy = $PathFollow2D/Enemy

func _ready():
	pathfollow.set_unit_offset(1)

func _process(delta):
	pathfollow.offset += 150 * delta
	if pathfollow.offset > 850:
		queue_free()
