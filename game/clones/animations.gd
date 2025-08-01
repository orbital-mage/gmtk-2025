extends Node

@export var clone: Clone

func _process(delta: float) -> void:
	if clone.sprite.animation == "zombify" and not clone.zombified:
		return
	
	_handle_running()
	_handle_aiming()
	_handle_invincibility(delta)

func _handle_running() -> void:
	if clone.zombified:
		clone.sprite.play("zombie")
		clone.sprite_color.play("zombie_color")
		clone.dust_particles.emitting = true
		clone.sounds.play_step()
		
		var flip_h = clone.velocity.x < 0
		clone.sprite.flip_h = flip_h
		clone.sprite_color.flip_h = flip_h
	elif clone.velocity.length() > 0:
		clone.sprite.play("run")
		clone.sprite_color.play("run_color")
		clone.dust_particles.emitting = true
		clone.sounds.play_step()
	else:
		clone.sprite.play("idle")
		clone.sprite_color.play("idle_color")
		clone.dust_particles.emitting = false
	
	var normVel: Vector2 = clone.velocity / clone.speed

	clone.sprite.rotation_degrees = lerp(
		clone.sprite.rotation_degrees, 
		normVel.x * 10, 
		0.5)
	clone.sprite.scale = clone.sprite.scale.lerp(
		Vector2(normVel.y * 0.2 + 1, -normVel.y * 0.1 + 1), 
		0.5)

func _handle_aiming() -> void:
	if clone.zombified:
		return
	
	var target = clone.aim_target
	var position = clone.global_position
	
	var direction = (target - position).normalized()
	
	var flip_h = target.x < position.x
	clone.sprite.flip_h = flip_h
	clone.sprite_color.flip_h = flip_h
	clone.gun_sprite.flip_v = flip_h
	
	var distance_multiplier = lerp(0.5, 1.0, abs(direction.x))
	clone.gun_sprite.position.x = 50 * distance_multiplier
	clone.gun_pivot.look_at(target)

func _handle_invincibility(delta: float) -> void:
	if clone.invincible:
		clone.sprite_color.modulate.h += delta
