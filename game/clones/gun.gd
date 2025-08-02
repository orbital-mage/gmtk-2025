class_name CloneGun extends Node2D

@onready var pivot: Node2D = $Pivot
@onready var sprite: AnimatedSprite2D = $Pivot/Sprite
@onready var discard_particle: GPUParticles2D = $Discard
@onready var shoot_particle: GPUParticles2D = $Pivot/Sprite/Particle
@onready var drink_particle: GPUParticles2D = $Drink

func aim(point: Vector2) -> void:
	pivot.look_at(point)

func get_barrel_position() -> Vector2:
	return sprite.global_position

func shoot_anim():
	sprite.stop()
	sprite.play("shoot")
	shoot_particle.restart()

func drink():
	drink_particle.global_position = sprite.global_position
	drink_particle.restart()

func discard() -> void:
	sprite.hide()
	discard_particle.global_position = sprite.global_position
	discard_particle.emitting = true

func reset() -> void:
	sprite.show()
