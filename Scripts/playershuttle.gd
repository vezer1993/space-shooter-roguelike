extends CharacterBody2D

const SPEED := 300.0
var is_flipped = false #state za rotaciju shuttla

const DODGE_DISTANCE := 150.0  
const DODGE_COOLDOWN := 1.0
var dodge_cooldown_timer: float = 0.0
var can_dodge: bool = true    

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
		
	
		
# doging 
	if dodge_cooldown_timer > 0:
		dodge_cooldown_timer -= delta
		can_dodge = false
	else:
		can_dodge = true
		
	if Input.is_action_just_pressed("dodge") and can_dodge:
		var horizontal_direction = Input.get_axis("move_left", "move_right")
		if horizontal_direction != 0:
			dodge(horizontal_direction)

func _physics_process(delta: float) -> void:
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	var vertical_direction := Input.get_axis("move_forward", "move_down")
	
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
	
	if velocity.length() > 0:
		$EngineEffectComponent.play_thrust()
	else:
		$EngineEffectComponent.play_idle() 
	
func rotate_shuttle():
	if not is_flipped:
		rotation = PI
		is_flipped = true
	else:
		rotation = 0
		is_flipped = false
		
func dodge(direction: float):
	#var tween = create_tween()
	if not can_dodge:
		return
	
	# Calculate dodge position
	var dodge_vector = Vector2(direction * DODGE_DISTANCE, 0)
	global_position += dodge_vector
	
	# Start cooldown
	dodge_cooldown_timer = DODGE_COOLDOWN
	can_dodge = false
	
	   
	#tween.tween_property(self, "modulate:a", 0.3, 0.1)  # Fade out
	#tween.tween_property(self, "modulate:a", 1.0, 0.1) 
