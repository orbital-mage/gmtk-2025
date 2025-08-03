class_name NukeWindupEffect extends Node2D

static var scene = preload("res://game/effects/nuke_windup.tscn")

static func create(clone: Clone) -> NukeWindupEffect:
	var effect = scene.instantiate() as NukeWindupEffect
	
	effect.user = clone
	
	return effect

var user: Clone

func _physics_process(_delta: float) -> void:
	position = user.position
