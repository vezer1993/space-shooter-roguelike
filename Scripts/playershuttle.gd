extends CharacterBody2D

const SPEED := 300.0

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
		$HealthShield.apply_damage(10)
		

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0.0  # Instant stop for crispness

	velocity.y = 0.0  # Lock vertical movement
	move_and_slide()
