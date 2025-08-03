class_name CloneHitbox extends Area2D

@export var clone: Clone

@onready var shape : CollisionShape2D = $CollisionShape2D

func disable() -> void:
	shape.disabled = true

func enable() -> void:
	shape.disabled = false
