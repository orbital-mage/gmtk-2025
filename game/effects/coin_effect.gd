class_name CoinEffect extends Node2D

static var scene = preload("res://game/effects/money_gain.tscn")

static func create(clone: Clone, amount: int = 1) -> CoinEffect:
	var effect = scene.instantiate() as CoinEffect
	
	effect.position = clone.position
	effect.get_node("Pivot/Box/Label").text = "+" + str(amount) if amount > 0 else str(amount)
	effect.get_node("Pivot/Box").modulate = Color(0.965, 0.714, 0.337) if amount > 0 else Color(1.0, 0.257, 0.326)
	
	return effect

func _on_animation_finished(_anim_name: StringName) -> void:
	queue_free()
