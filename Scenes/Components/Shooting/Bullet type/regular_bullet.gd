extends CharacterBody2D

var speed: float = 500.0
var direction: Vector2 = Vector2.RIGHT
var lifetime: float = 10.0  # Remove after 5 seconds
var time_alive: float = 0.0
var damage: int = 10

func _ready():
	$AnimatedSprite2D.play()  # Start the animation
	velocity = direction * speed

func _physics_process(delta):
	# Move the bullet
	velocity = direction * speed
	move_and_slide()
	
	 # Track lifetime
	time_alive += delta
	if time_alive >= lifetime:
		queue_free()
		return
	
	# Check if bullet hit something
	if get_slide_collision_count() > 0:
		var collider = get_slide_collision(0).get_collider()
		if collider.has_node("HP"):
			collider.get_node("HP").apply_damage(damage)
		# Hit something - destroy bullet
		queue_free()
