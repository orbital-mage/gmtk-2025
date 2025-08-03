class_name Nuke extends Node2D

static var scene = preload("res://game/items/nuke.tscn")

static func create(clone: Clone) -> Nuke:
	var nuke = scene.instantiate() as Nuke
	
	nuke.user = clone
	
	return nuke

var user: Clone

func _on_timeout() -> void:
	if user.dead:
		queue_free()
		return
	
	Arena.add_effect.emit(NukeEffect.create())
	
	for clone: Clone in get_tree().get_nodes_in_group("clones"):
		clone.die(user)
