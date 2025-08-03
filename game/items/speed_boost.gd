extends Item

func use(clone: Clone, _target: Vector2) -> void:
	clone.speed *= 1.5
