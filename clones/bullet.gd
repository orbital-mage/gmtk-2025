class_name Bullet extends Node2D

@export var speed: float = 2000

var direction: Vector2

@onready var hitbox: Area2D = $Hitbox

func set_target(target: Vector2):
	direction = (target - position).normalized()

func _physics_process(delta: float) -> void:
	position += direction * delta * speed

func _on_lifetime_timeout() -> void:
	queue_free()

func _on_released(area: Area2D) -> void:
	hitbox.set_collision_layer_value(2, true)
