extends Item

func use(clone: Clone, _target: Vector2) -> void:
	clone.get_parent().add_child(Decoy.create(clone))
