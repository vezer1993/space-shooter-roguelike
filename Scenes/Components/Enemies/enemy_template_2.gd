extends Path2D


@onready var path_follow := $PathFollow2D
@onready var path2d := $"."  # parent of PathFollow2D

@export var speed := 100.0
var done := false

func _process(delta):
	if done:
		global_position.y += speed * delta  # Continue downward
		return

	path_follow.progress += speed * delta

	var path_length: float = path2d.curve.get_baked_length()
	if path_follow.progress >= path_length:
		done = true
