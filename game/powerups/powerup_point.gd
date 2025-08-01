extends Node2D

static var pellet_scene = preload("res://game/powerups/pellet.tscn")

func _ready() -> void:
	Arena.new_round.connect(_on_new_round)

func _on_new_round() -> void:
	add_child(pellet_scene.instantiate())
