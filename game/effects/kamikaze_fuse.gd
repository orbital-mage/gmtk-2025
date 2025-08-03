class_name FuseEffect extends Node2D

static var scene = preload("res://game/effects/kamikaze_fuse.tscn")

static func create(clone: Clone) -> FuseEffect:
	var effect = scene.instantiate() as FuseEffect
	
	effect.user = clone
	
	return effect

var user: Clone

func _physics_process(delta: float) -> void:
	position = user.position
