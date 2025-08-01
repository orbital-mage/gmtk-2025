class_name DeathEffect extends Node2D

static var scene = preload("res://game/effects/death.tscn")

static func create(clone: Clone) -> DeathEffect:
	var effect = scene.instantiate() as DeathEffect
	
	effect.position = clone.position
	effect.set_color(clone.get_color())
	
	return effect

var color: Color

@export var colored: Array[CanvasItem]

func _ready() -> void:
	for item: CanvasItem in colored:
		item.modulate = color

func set_color(value: Color) -> void:
	color = value
