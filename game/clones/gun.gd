class_name CloneGun extends Node2D

@onready var sprite: Sprite2D = $Gun
@onready var discard_particle: GPUParticles2D = $Discard

func aim(point: Vector2) -> void:
	look_at(point)

func get_barrel_position() -> Vector2:
	return sprite.global_position

func discard() -> void:
	sprite.hide()
	discard_particle.emitting = true

func reset() -> void:
	sprite.show()
