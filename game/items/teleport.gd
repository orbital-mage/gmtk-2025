class_name Teleport extends Item

func use(clone: Clone, target: Vector2) -> void:
	Arena.add_effect.emit(TeleportEffect.create(clone))
	
	var space_state = clone.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		clone.global_position, 
		target, 
		Collision.create_mask([Collision.Layers.BOUNDS]))
	var result = space_state.intersect_ray(query)
	
	if not result:
		clone.position = target
	else:
		clone.position = result.position
