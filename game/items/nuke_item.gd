extends Item

func use(clone: Clone, _target: Vector2) -> void:
	Arena.add_effect.emit(Nuke.create(clone))
	Arena.add_effect.emit(NukeUseEffect.create(clone))
