extends Sprite2D


func _ready():
	# Fade out over time
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)  # Fade to transparent
	tween.tween_callback(queue_free)  # Remove when done

func setup(original_sprite: Sprite2D, start_alpha: float = 0.6):
	# Copy the original sprite's appearance
	texture = original_sprite.texture
	global_position = original_sprite.global_position
	rotation = original_sprite.rotation
	scale = original_sprite.scale
	modulate.a = start_alpha
