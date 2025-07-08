extends Area2D

@export var powerup_type: String = "health"  # "health", "speed", "damage"
@export var hp_value: int = 25
@export var xp_value: int
@export var shield_value: int

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
