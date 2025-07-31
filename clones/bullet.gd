class_name Bullet extends Node2D

var direction: Vector2

@onready var hitbox: Area2D = $Hitbox

func set_target(target: Vector2):
	direction = (target - position).normalized()

func _physics_process(delta: float) -> void:
	position += direction * delta * 1000

func _on_lifetime_timeout() -> void:
	queue_free()

func _on_released(area: Area2D) -> void:
	hitbox.set_collision_layer_value(2, true)
