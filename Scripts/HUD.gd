extends CanvasLayer

@onready var hp_bar = $VBoxContainer/HPBar
@onready var hp_bar_red = $VBoxContainer/HPBarRed
@onready var label = hp_bar.get_node("ValueLabel")
var health
var base_bar_width := 200.0  # Starting width, adjust to match your design

func _ready():
	var player = $"../../playerShuttle"  # adjust path as needed
	health = player.get_node("HealthShield")


	# 🔹 Call once immediately with current values
	update_health(health.hp, health.max_hp)
	

func update_health(current: int, max: int):
	var from_value = hp_bar.value

	# Update max HP immediately
	hp_bar.max_value = max

	# Animate HP fill to current value
	if(current < from_value):
		await animate_bar_value(from_value, current)

	# Update label during/after fill animation
	label.text = str(current, " / ", max)

	# Delay and animate red trail rollback
	if(current < from_value):
		animate_red_bar(hp_bar_red.value, current)

	# Shake both bars
	if(current < max):
		shake_bar(hp_bar)
		shake_bar(hp_bar_red)

func update_max_health(current: int, new_max_hp: int):
	print("UPDATING MAX HP:", new_max_hp)

	# Calculate target width based on new max HP
	var old_width = base_bar_width
	base_bar_width = calculate_bar_width(new_max_hp)

	# Animate visual width of both bars
	await animate_bar_width(old_width, base_bar_width)

	# Update green bar values
	hp_bar.max_value = new_max_hp
	hp_bar.value = current
	label.text = str(current, " / ", new_max_hp)

	# Update red bar max (scale), but delay fill animation
	hp_bar_red.max_value = new_max_hp

	await get_tree().create_timer(0.2).timeout
	await animate_red_bar(hp_bar_red.value, current)

	
func calculate_bar_width(max_hp: int) -> float:
	var per_hp = 2.0  # pixels per HP, tweak as desired
	return max_hp * per_hp

func animate_red_bar(from: float, to: float):
	var duration = 0.3
	var t := 0.0
	while t < duration:
		t += get_process_delta_time()
		var v = lerp(from, to, t / duration)
		hp_bar_red.value = v
		await get_tree().process_frame
	hp_bar_red.value = to

func animate_bar_value(from: float, to: float, duration := 0.3):
	var t = 0.0
	while t < duration:
		t += get_process_delta_time()
		var value = lerp(from, to, t / duration)
		hp_bar.value = value
		await get_tree().process_frame
	hp_bar.value = to

func animate_bar_width(from: float, to: float, duration := 0.4):
	var t := 0.0
	while t < duration:
		t += get_process_delta_time()
		var width: float = lerp(from, to, t / duration)
		
		# Set width of both bars
		hp_bar.custom_minimum_size.x = width
		hp_bar_red.custom_minimum_size.x = width

		# Set max_value of red to match green
		hp_bar_red.max_value = hp_bar.max_value


		await get_tree().process_frame

	# Final match to ensure perfect sync
	hp_bar.custom_minimum_size.x = to
	hp_bar_red.custom_minimum_size.x = to
	hp_bar_red.max_value = hp_bar.max_value

func shake_bar(bar: Control, intensity := 4, duration := 0.2):
	var original_pos = bar.position
	var t = 0.0
	while t < duration:
		t += get_process_delta_time()
		var offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		bar.position = original_pos + offset
		await get_tree().process_frame
	bar.position = original_pos
