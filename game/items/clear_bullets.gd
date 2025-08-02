class_name ClearBullets extends Item

func use(clone: Clone, _target: Vector2) -> void:
	Arena.add_effect.emit(FlashEffect.create())
	
	for bullet: Bullet in clone.get_tree().get_nodes_in_group("bullets"):
		bullet.queue_free()
