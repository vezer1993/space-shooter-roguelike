extends CharacterBody2D

const SPEED := 300.0
var is_flipped = false #state za rotaciju shuttla

func _ready():
	var hud = get_node("../Camera2D/HUD")  # Or wherever your HUD is
	var health_component = $HealthShield  # Assuming this script is on the player

	# Connect the health_changed signal to the HUD
	health_component.health_changed.connect(hud.update_health)
	health_component.health_max_changed.connect(hud.update_max_health)
	
	
#TESTING
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):  # e.g. spacebar
		$HealthShield.increase_max_hp(25)
	if Input.is_action_just_pressed("fire"):  # e.g. spacebar
		$"%ShootingComponent".shoot()
	if Input.is_action_just_pressed("rotate"):
		rotate_shuttle()
		

func _physics_process(delta: float) -> void:
	var horizontal_direction := Input.get_axis("ui_left", "ui_right")
	var vertical_direction := Input.get_axis("ui_up", "ui_down")
	
	if horizontal_direction != 0:
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = 0.0  # Instant stop for crispness
	
	# Set vertical velocity
	if vertical_direction != 0:
		velocity.y = vertical_direction * SPEED
	else:
		velocity.y = 0.0  # Instant stop for crispness
		
	move_and_slide()
	
func rotate_shuttle():
	if not is_flipped:
		rotation = PI
		is_flipped = true
	else:
		rotation = 0
		is_flipped = false
