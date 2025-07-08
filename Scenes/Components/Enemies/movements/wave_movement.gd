extends Node2D

@export var amplitude_x_range := Vector2(40.0, 120.0)
@export var amplitude_y_range := Vector2(30.0, 70.0)
@export var wave_speed_range := Vector2(1.0, 2.0)
@export var base_speed := 40.0
@export var margin := 40.0

var lifetime := 0.0
var center_position: Vector2
var amplitude_x := 100.0
var amplitude_y := 60.0
var wave_speed := 1.5
var screen_size := Vector2.ZERO

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	await get_tree().process_frame
	center_position = get_parent().global_position
	_generate_pattern_inside_screen()

func _process(delta):
	lifetime += delta

	# Apply wave-based offset movement
	var x_offset = amplitude_x * cos(lifetime * wave_speed)
	var y_offset = amplitude_y * sin(lifetime)
	var new_pos = center_position + Vector2(x_offset, y_offset + lifetime * base_speed)

	get_parent().global_position = new_pos

	# Auto-queue_free if off-screen bottom
	if new_pos.y > screen_size.y + 100:
		get_parent().queue_free()

func _generate_pattern_inside_screen():
	var max_amp_x = min(center_position.x - margin, screen_size.x - center_position.x - margin)
	max_amp_x = max(max_amp_x, amplitude_x_range.x)  # ensure minimum room to move

	amplitude_x = randf_range(amplitude_x_range.x, min(amplitude_x_range.y, max_amp_x))
	amplitude_y = randf_range(amplitude_y_range.x, amplitude_y_range.y)
	wave_speed = randf_range(wave_speed_range.x, wave_speed_range.y)
