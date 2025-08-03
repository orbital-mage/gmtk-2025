extends Item

const radius := 500

func use(clone: Clone, _target: Vector2) -> void:
	clone.died.connect(_on_clone_died)
	Arena.new_round.connect(_on_reset)

func _on_clone_died(user: Clone) -> void:
	for clone: Clone in user.get_tree().get_nodes_in_group("clones"):
		if clone == user:
			continue
		
		if (clone.position - user.position).length() < radius:
			clone.die(user)

func _on_reset() -> void:
	queue_free()
