extends CharacterBody2D

func _ready():
	if $HP:
		$HP.died.connect(_on_died)
		$HP.health_changed.connect(_on_takeDMG)

func _on_died():
	print("Enemy died")

func _on_takeDMG(hp: float, maxHP: float):
	print("Enemy HP:", hp, "/", maxHP)
