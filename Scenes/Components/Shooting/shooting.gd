extends Node2D
class_name ShootingComponent

@export var bullet_scene: PackedScene # služi da možemo dodati metke
@export var fire_rate: float = 0.5  
@export var bullet_speed: float = 500.0

var time_since_last_shot: float = 0.0


func _process(delta):
	time_since_last_shot += delta

func can_shoot() -> bool:
	return time_since_last_shot >= fire_rate

func shoot():
	if not can_shoot():
		return false
	print("Shuttle rotation (degrees): ", rad_to_deg(get_parent().rotation))
	print("Shuttle rotation (radians): ", get_parent().rotation)
	
	# Create bullet
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $BulletSpawnPoint.global_position
	
	if get_parent().is_flipped:
		bullet.direction = Vector2.DOWN  # Flipped = shoot down
		bullet.rotation = PI
	else:
		bullet.direction = Vector2.UP
		bullet.rotation = 0 
	
	print("Bullet direction: ", bullet.direction)
	
	# Add bullet to scene
	get_tree().current_scene.add_child(bullet)
	
	# Reset cooldown
	time_since_last_shot = 0.0
	return true
