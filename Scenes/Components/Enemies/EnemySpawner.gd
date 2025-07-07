extends Node2D

@export var enemy_scenes: Array[PackedScene]  # Drag & drop enemy scenes in the editor
@export var spawn_list: Array[Dictionary]     # Describes waves/spawns
@export var enabled: bool


var enemy_container

func _ready():
	enemy_container = get_node("../Enemies")
	
	spawn_list = [
		{ "enemy": 0, "count": 1, "delay": 2.5, "area": Rect2(100, -80, 600, 50) },
		{ "enemy": 0, "count": 1, "delay": 2.5, "area": Rect2(20, -80, 600, 50) },
		{ "enemy": 0, "count": 1, "delay": 2.5, "area": Rect2(150, -80, 600, 50) },
	]
	
	if(enabled):
		start_spawning()

func start_spawning():
	call_deferred("_process_spawn_list")

func _process_spawn_list():
	for spawn in spawn_list:
		var delay: float = spawn.get("delay", 0.0)
		await get_tree().create_timer(delay).timeout

		var scene_idx: int = spawn.get("enemy", 0)
		var count: int = spawn.get("count", 1)
		var area: Rect2 = spawn.get("area", Rect2(200, -100, 400, 50))	

		for i in count:
			var enemy = enemy_scenes[scene_idx].instantiate()
			var pos = area.position + Vector2(
				randf_range(0, area.size.x),
				randf_range(0, area.size.y)
			)
			enemy.global_position = pos
			enemy_container.add_child(enemy)
