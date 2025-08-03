class_name ScatterShotEffect extends Node2D

static var scene = preload("res://game/effects/scatter_shot.tscn")

static func create(clone: Clone) -> ScatterShotEffect:
	var effect = scene.instantiate() as ScatterShotEffect
	
	effect.position = clone.position
	
	return effect
