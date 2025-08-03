class_name Tutorial extends Node2D

static var scene = preload("res://game/tutorial.tscn")

@onready var label: Label = $Pivot/Label
@onready var animation: AnimationPlayer = $AnimationPlayer

static var shown_tutorials: Dictionary[String, bool]

static func create(clone: Clone, text: String = "YOU", key: String = "", slow: bool = false):
	if key != "" && shown_tutorials.has(key):
		return
	shown_tutorials[key] = true
	var effect: Tutorial = scene.instantiate() as Tutorial
	
	clone.add_child(effect)
	if slow:
		effect.animation.speed_scale = 0.5
	effect.label.text = text
