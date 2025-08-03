class_name NukeEffect extends Node2D

static var scene = preload("res://game/effects/nuke.tscn")

static func create() -> NukeEffect:
	return scene.instantiate()
