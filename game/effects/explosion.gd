class_name ExplodeEffect extends Node2D

static var scene = preload("res://game/effects/kamikaze_explosion.tscn")

static func create(clone: Clone) -> ExplodeEffect:
	var effect = scene.instantiate() as ExplodeEffect
	
	effect.position = clone.position
	
	return effect

func _ready() -> void:
	$Particle.emitting = true
