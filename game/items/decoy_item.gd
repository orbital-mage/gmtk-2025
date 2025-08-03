extends Item

func use(clone: Clone, _target: Vector2) -> void:
	Arena.add_effect.emit(Decoy.create(clone))
