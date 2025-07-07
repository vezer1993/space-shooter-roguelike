extends CharacterBody2D

var lifetime := 0.0
var center_position: Vector2
var amplitude_x: float
var amplitude_y: float
var speed: float
var frequency: float

func _ready():
	
	var hp = $HP
	hp.died.connect(_on_died)
	hp.health_changed.connect(_on_takeDMG)
	
	center_position = global_position
	amplitude_x = randf_range(50.0, 150.0)
	amplitude_y = randf_range(30.0, 100.0)
	speed = randf_range(0.8, 1.5)
	frequency = randf_range(1.0, 2.5)

func _process(delta):
	lifetime += delta
	var t = lifetime * speed
	var offset = Vector2(
		amplitude_x * cos(t * frequency),
		amplitude_y * sin(t)
	)
	global_position = center_position + offset + Vector2(0, t * 20)  # slowly drifts down

	# Optional: despawn if far off screen
	if global_position.y > 1000 or global_position.x < -200 or global_position.x > 2000:
		queue_free()


func _on_died():
	print("dead")
	
func _on_takeDMG(hp: float, maxHP: float):
	print("enemy damaged")
