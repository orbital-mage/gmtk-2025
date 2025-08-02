class_name Teleport extends Item

func use(clone: Clone, target: Vector2) -> void:
	clone.position = target
