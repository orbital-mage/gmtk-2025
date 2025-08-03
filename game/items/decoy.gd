class_name Decoy extends Node2D

static var scene = preload("res://game/items/decoy.tscn")

static func create(clone: Clone) -> Decoy:
	var decoy = scene.instantiate() as Decoy
	
	decoy.position = clone.position
	
	return decoy

func _on_hit(area: Area2D) -> void:
	if area is CloneHitbox:
		queue_free()
