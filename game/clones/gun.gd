class_name CloneGun extends Node2D

@onready var pivot: Node2D = $Pivot
@onready var sprite: Sprite2D = $Pivot/Sprite
@onready var discard_particle: GPUParticles2D = $Discard

func aim(point: Vector2) -> void:
	pivot.look_at(point)

func get_barrel_position() -> Vector2:
	return sprite.global_position

func discard() -> void:
	sprite.hide()
	discard_particle.emitting = true

func reset() -> void:
	sprite.show()
