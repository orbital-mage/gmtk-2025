class_name TeleportEffect extends Node2D

static var scene = preload("res://game/effects/teleport.tscn")

static func create(clone: Clone) -> TeleportEffect:
	var effect = scene.instantiate() as TeleportEffect
	
	effect.position = clone.position
	
	return effect
