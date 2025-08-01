extends Node

static var clone_scene = preload("res://game/clones/clone.tscn")

signal coins_changed()

var clone: Clone
var coins := 0

func new_clone() -> Clone:
	clone = clone_scene.instantiate()
	return clone

func add_coin() -> void:
	coins += 1
	coins_changed.emit()
