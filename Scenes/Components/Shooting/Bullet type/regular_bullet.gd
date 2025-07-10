extends Area2D

var speed: float = 500.0
var direction: Vector2 = Vector2.UP
var lifetime: float = 10.0
var time_alive: float = 0.0
var damage: int = 10

func _ready():
	$AnimatedSprite2D.play()

func _physics_process(delta):
	# Move the bullet manually
	position += direction * speed * delta
	
	# Track lifetime
	time_alive += delta
	if time_alive >= lifetime:
		queue_free()

func _on_area_entered(area):
	# Hit an enemy (Area2D)
	if area.has_node("HP"):
		area.get_node("HP").apply_damage(damage)
	queue_free()

func _on_body_entered(body):
	# Hit something else (CharacterBody2D, StaticBody2D, etc.)
	if body.has_node("HP"):
		body.get_node("HP").apply_damage(damage)
	queue_free()
