extends Node2D

@export var enemy_scenes: Array[PackedScene]
@export var enabled: bool = true

var spawn_list: Array[Dictionary] = []
var enemy_container: Node

func _ready():
	enemy_container = get_node("../Enemies")

	spawn_list = [
		{ "enemy": 0, "count": 1, "delay": 1.0, "side": "top" },
		{ "enemy": 0, "count": 1, "delay": 2.5, "side": "left" },
		{ "enemy": 0, "count": 1, "delay": 2.5, "side": "right" },
		{ "enemy": 0, "count": 1, "delay": 4.0, "side": "random" }
	]

	if enabled:
		start_spawning()

func start_spawning():
	call_deferred("_process_spawn_list")

func _process_spawn_list():
	for spawn in spawn_list:
		var delay: float = spawn.get("delay", 0.0)
		await get_tree().create_timer(delay).timeout

		var scene_idx: int = spawn.get("enemy", 0)
		var count: int = spawn.get("count", 1)
		var side: String = spawn.get("side", "top")
		var area := get_spawn_area(side)

		for i in count:
			var enemy = enemy_scenes[scene_idx].instantiate()
			var pos = area.position + Vector2(
				randf_range(0, area.size.x),
				randf_range(0, area.size.y)
			)
			enemy.global_position = pos
			enemy_container.add_child(enemy)

func get_spawn_area(side: String) -> Rect2:
	var screen_size = get_viewport().get_visible_rect().size
	var y := -80  # consistent spawn just above screen
	var height := 50
	
	match side:
		"top":
			var x := randf_range(screen_size.x * 0.4, screen_size.x * 0.6)
			return Rect2(x, y, 1, height)  # single point
		"left":
			var x := randf_range(screen_size.x * -0.1, screen_size.x * 0.4)
			return Rect2(x, y, 1, height)
		"right":
			var x := randf_range(screen_size.x * 0.6, screen_size.x * 0.9)
			return Rect2(x, y, 1, height)
		"random":
			var sides = ["top", "left", "right"]
			return get_spawn_area(sides[randi() % sides.size()])
		_:
			var x := randf_range(screen_size.x * 0.4, screen_size.x * 0.6)
			return Rect2(x, y, 1, height)
