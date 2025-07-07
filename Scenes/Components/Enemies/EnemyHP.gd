extends Node2D

signal health_changed(current: int, max: int)
signal died

@export var max_hp: int = 100
var hp: int

func _ready():
	hp = max_hp
	emit_signal("health_changed", hp, max_hp)

func apply_damage(amount: int):
	hp = max(hp - amount, 0)
	emit_signal("health_changed", hp, max_hp)

	if hp == 0:
		emit_signal("died")
		if owner:
			owner.queue_free()  # destroy enemy/player node
