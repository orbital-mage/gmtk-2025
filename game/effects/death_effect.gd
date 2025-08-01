class_name DeathEffect extends Node2D

static var scene = preload("res://game/effects/death.tscn")

static func create(clone: Clone) -> DeathEffect:
	var effect = scene.instantiate() as DeathEffect
	
	effect.position = clone.position
	effect.set_color(clone.color)
	
	return effect

var color: Color

@onready var cap_color: Sprite2D = $Cap/Color
@onready var bandana: GPUParticles2D = $Bandana

func _ready() -> void:
	cap_color.modulate = color
	bandana.modulate = color

func set_color(value: Color) -> void:
	color = value

func _on_animation_finished(anim_name: StringName) -> void:
	queue_free()
