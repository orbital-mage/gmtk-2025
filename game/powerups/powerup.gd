class_name Powerup extends Node2D

static var scene = preload("res://game/powerups/powerup.tscn")

static func random() -> Powerup:
	var powerup = scene.instantiate() as Powerup
	powerup.type = Type.keys()[randi_range(0, Type.size() - 1)]
	
	return powerup

enum Type { SCATTER_SHOT, INVINCIBILITY }

var type: Type

func _on_collected(area: Area2D) -> void:
	queue_free()
