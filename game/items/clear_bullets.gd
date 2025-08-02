class_name ClearBullets extends Item

func use(clone: Clone, _target: Vector2) -> void:
	for bullet: Bullet in clone.get_tree().get_nodes_in_group("bullets"):
		bullet.queue_free()
