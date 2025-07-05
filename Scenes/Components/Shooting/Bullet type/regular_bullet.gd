extends CharacterBody2D

var speed: float = 500.0
var direction: Vector2 = Vector2.RIGHT

func _ready():
	$AnimatedSprite2D.play()  # Start the animation
	velocity = direction * speed

func _physics_process(delta):
	# Move the bullet
	velocity = direction * speed
	move_and_slide()
	
	# Check if bullet hit something
	if get_slide_collision_count() > 0:
		# Hit something - destroy bullet
		queue_free()
