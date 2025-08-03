extends Item

func use(clone: Clone, _target: Vector2) -> void:
	Arena.add_effect.emit(SpeedEffect.create(clone))
	clone.speed *= 1.5
