class_name SpeedEffect extends Node2D

static var scene = preload("res://game/effects/speed.tscn")

static func create(clone: Clone) -> SpeedEffect:
	var effect = scene.instantiate() as SpeedEffect
	
	effect.position = clone.position
	
	return effect
