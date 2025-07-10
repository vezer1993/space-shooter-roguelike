extends Area2D

func _ready():
	if $HP:
		$HP.died.connect(_on_died)
		$HP.health_changed.connect(_on_takeDMG)

func _on_died():
	print("Enemy died")
	queue_free()

func _on_takeDMG(hp: float, maxHP: float):
	print("Enemy HP:", hp, "/", maxHP)


func _on_body_entered(body: Node2D) -> void:
	print("Enemy collided with player!")
	if body.name == "playerShuttle" or body.has_node("HealthShield"):
		body.get_node("HealthShield").apply_damage(20)
		_on_died() #stavija sam ovo iako nzm jel ti treba _on_died, umisto toga bi ode išlo queue_free koji sma stavija u _on_died_
