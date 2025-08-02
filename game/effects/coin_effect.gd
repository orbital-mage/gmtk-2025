class_name CoinEffect extends Node2D

static var scene = preload("res://game/effects/money_gain.tscn")

static func create(clone: Clone) -> CoinEffect:
	var effect = scene.instantiate() as CoinEffect
	
	effect.position = clone.position
	
	return effect

func _on_animation_finished(_anim_name: StringName) -> void:
	queue_free()
