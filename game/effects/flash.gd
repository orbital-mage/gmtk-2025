class_name FlashEffect extends Node2D

static var scene = preload("res://game/effects/flash.tscn")

static func create() -> FlashEffect:
	return scene.instantiate()
