extends CanvasLayer

@onready var hp_bar = $VBoxContainer/HPBar
@onready var hp_bar_red = $VBoxContainer/HPBarRed
@onready var label = hp_bar.get_node("ValueLabel")
var health

func _ready():
	var player = $"../../playerShuttle"  # adjust path as needed
	health = player.get_node("HealthShield")


	# 🔹 Call once immediately with current values
	update_health(health.hp, health.max_hp)
	
	await test_fake_damage()

@warning_ignore("redundant_await")
func test_fake_damage():
	await get_tree().create_timer(3.0).timeout
	print("Simulating damage...")
	health.apply_damage(25)

func update_health(current: int, max: int):
	hp_bar.max_value = max
	hp_bar.value = current
	label.text = str(current, " / ", max)

	await get_tree().create_timer(0.2).timeout
	animate_red_bar(hp_bar_red.value, current)

	shake_bar(hp_bar)
	shake_bar(hp_bar_red)

func animate_red_bar(from: float, to: float):
	var duration = 0.3
	var t := 0.0
	while t < duration:
		t += get_process_delta_time()
		var v = lerp(from, to, t / duration)
		hp_bar_red.value = v
		await get_tree().process_frame
	hp_bar_red.value = to

func shake_bar(bar: Control, intensity := 4, duration := 0.2):
	var original_pos = bar.position
	var t = 0.0
	while t < duration:
		t += get_process_delta_time()
		var offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		bar.position = original_pos + offset
		await get_tree().process_frame
	bar.position = original_pos
