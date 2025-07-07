extends CharacterBody2D

const SPEED := 300.0
var is_flipped = false #state za rotaciju shuttla

const DODGE_DISTANCE := 150.0  
const DODGE_COOLDOWN := 1.0
var dodge_cooldown_timer: float = 0.0
var can_dodge: bool = true
var is_dodging: bool = false   

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
	var direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_forward", "move_down")
	)

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

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
	if not can_dodge:
		return
	
	can_dodge = false
	
	# Calculate target position
	var start_position = global_position
	var target_position = global_position + Vector2(direction * DODGE_DISTANCE, 0)
	
	# Create smooth movement with tween
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)  
	tween.set_trans(Tween.TRANS_SINE)  
	
	# Animate to target position
	tween.tween_property(self, "global_position", target_position, 0.2)  # 0.2 seconds
	
	# When done
	tween.tween_callback(func():
		dodge_cooldown_timer = DODGE_COOLDOWN
	)
	
	# Create afterimages during the slide
	create_sliding_afterimages(start_position, target_position)

func create_sliding_afterimages(start_pos: Vector2, end_pos: Vector2):
	var afterimage_scene = preload("res://Scenes/Components/EngineEffects/after_image.tscn")
	var sprite = $"MainShip-Base-FullHealth"
	
	# Create afterimages along the path
	for i in range(5):
		var progress = float(i) / 4.0
		var afterimage_position = start_pos.lerp(end_pos, progress)
		
		var afterimage = afterimage_scene.instantiate()
		get_tree().current_scene.add_child(afterimage)
		afterimage.setup(sprite, 0.4 - (i * 0.1))
		afterimage.global_position = afterimage_position
	
