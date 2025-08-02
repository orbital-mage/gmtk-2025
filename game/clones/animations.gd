class_name CloneAnimations extends Node

@export var clone: Clone
@export var sprite: AnimatedSprite2D
@export var sprite_color: AnimatedSprite2D
@export var dust_particles: GPUParticles2D
@export var gun: CloneGun

var color: Color
var spawning := false

func set_color(value: Color) -> void:
	color = value
	sprite_color.modulate = color

func reset() -> void:
	sprite.play("sleep")
	sprite_color.play("sleep_color")
	sprite_color.modulate = color
	gun.reset()

func zombify() -> void:
	sprite.play("zombify")
	sprite_color.play("zombify_color")
	sprite_color.modulate = get_color()
	
	dust_particles.emitting = false
	gun.discard()

func get_color() -> Color:
	if clone.is_replay_finished():
		return color.darkened(0.5)
	
	return color

func _process(delta: float) -> void:
	if sprite.animation == "sleep":
		if not Arena.paused:
			sprite.play("spawn")
			sprite_color.play("spawn_color")
		return
	
	if sprite.animation == "spawn":
		return
	
	if sprite.animation == "zombify" and not clone.zombified:
		return
	
	_handle_running()
	_handle_aiming()
	_handle_invincibility(delta)

func _on_sprite_animation_finished() -> void:
	if sprite.animation == "spawn":
		sprite.play("idle")
		sprite_color.play("idle_color")

func _handle_running() -> void:
	if clone.zombified:
		sprite.play("zombie")
		sprite_color.play("zombie_color")
		dust_particles.emitting = true
		clone.sounds.play_step()
		
		var flip_h = clone.velocity.x < 0
		sprite.flip_h = flip_h
		sprite_color.flip_h = flip_h
	elif clone.velocity.length() > 0:
		sprite.play("run")
		sprite_color.play("run_color")
		dust_particles.emitting = true
		clone.sounds.play_step()
	else:
		sprite.play("idle")
		sprite_color.play("idle_color")
		dust_particles.emitting = false
	
	var normVel: Vector2 = clone.velocity / clone.speed

	sprite.rotation_degrees = lerp(
		sprite.rotation_degrees, 
		normVel.x * 10, 
		0.5)
	sprite.scale = sprite.scale.lerp(
		Vector2(normVel.y * 0.2 + 1, -normVel.y * 0.1 + 1), 
		0.5)

func _handle_aiming() -> void:
	if clone.zombified:
		return
	
	var target = clone.aim_target
	var position = clone.global_position
	
	var direction = (target - position).normalized()
	
	var flip_h = target.x < position.x
	sprite.flip_h = flip_h
	sprite_color.flip_h = flip_h
	gun.scale.y = -1 if flip_h else 1
	
	var distance_multiplier = lerp(0.5, 1.0, abs(direction.x))
	gun.sprite.position.x = 50 * distance_multiplier
	clone.gun.aim(target)

func _handle_invincibility(delta: float) -> void:
	if clone.invincible:
		sprite_color.modulate.h += delta
	else:
		sprite_color.modulate = get_color()
