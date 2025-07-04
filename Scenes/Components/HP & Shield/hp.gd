extends Node2D

@export var max_hp: int = 100
@export var max_shield: int = 0
@export var shield_regen_rate: float = 0.0
@export var shield_regen_delay: float = 3.0

var hp: int
var shield: float
var time_since_last_hit: float = 0.0

signal died
signal health_changed(hp, max_hp, shield, max_shield)
signal health_max_changed(hp, max_hp)

func _ready():
	hp = max_hp
	shield = max_shield

func _process(delta):
	time_since_last_hit += delta

	if time_since_last_hit > shield_regen_delay and shield < max_shield:
		shield += shield_regen_rate * delta
		shield = min(shield, max_shield)
		emit_signal("health_changed", hp, max_hp)
		
func increase_max_hp(amount: int):
	max_hp = max_hp + amount
	hp = hp + amount
	emit_signal("health_max_changed", hp, max_hp)

func apply_damage(amount: int) -> void:
	time_since_last_hit = 0.0

	if shield > 0:
		var remaining = amount - shield
		shield = max(shield - amount, 0)

		if remaining > 0:
			hp = max(hp - remaining, 0)
	else:
		hp = max(hp - amount, 0)

	emit_signal("health_changed", hp, max_hp)

	if hp <= 0:
		emit_signal("died")
