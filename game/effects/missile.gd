class_name MissileEffect extends Node2D

static var scene = preload("res://game/effects/missile.tscn")

static func create(clone: Clone) -> MissileEffect:
	var effect = scene.instantiate() as MissileEffect
	
	effect.position = clone.position
	
	return effect
