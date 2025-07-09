extends Area2D

@export var powerup_type: String = "health"  # "health", "speed", "damage"
@export var hp_value: int = 25
@export var xp_value: int
@export var shield_value: int


func _ready():
	start_warning_blink()
	
func _on_body_entered(body):
	apply_powerup(body)
	queue_free()

func apply_powerup(player):
	match powerup_type:
		"health":
			player.get_node("HealthShield").increase_max_hp(hp_value)
		"shield":
			player.get_node("HealthShield").increase_max_hp(shield_value)
		"xp":
			print("Player got +", xp_value, " damage!")

func _on_timer_timeout() -> void:
	queue_free()
	

func start_warning_blink():
	# Start blinking when 2 seconds remain
	var warning_delay = max(0.0, $Timer.wait_time - 2.0)
	
	if warning_delay > 0:
		await get_tree().create_timer(warning_delay).timeout
		blink_warning()

func blink_warning():
	# Blink to warn player powerup is about to expire
	var tween = create_tween()
	tween.set_loops()  # Loop indefinitely
	tween.tween_property(self, "modulate:a", 0.3, 0.2)
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
