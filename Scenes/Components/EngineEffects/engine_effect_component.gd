extends Node2D


class_name EngineEffectComponent

@export var idle_animation: String = "idle"
@export var thrust_animation: String = "thrust"
@export var power_up_animation: String = "power_up"

var animated_sprite: AnimatedSprite2D
var current_state: String = ""

func _ready():
	animated_sprite = $AnimatedSprite2D
	play_idle()

func play_idle():
	if current_state != idle_animation:
		animated_sprite.play("Idle")
		current_state = idle_animation

func play_thrust():
	if current_state != thrust_animation:
		animated_sprite.play(thrust_animation)
		current_state = thrust_animation

func play_power_up():
	if current_state != power_up_animation:
		animated_sprite.play(power_up_animation)
		current_state = power_up_animation
