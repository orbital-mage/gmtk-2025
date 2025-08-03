class_name NukeUseEffect extends Node2D

static var scene = preload("res://game/effects/nuke_use.tscn")

static func create(clone: Clone) -> NukeUseEffect:
	var effect = scene.instantiate() as NukeUseEffect
	
	effect.position = clone.position
	
	return effect
