extends Node2D

static var powerup_scene = preload("res://game/powerups/powerup.tscn")

func _ready() -> void:
	Arena.new_round.connect(_on_new_round)

func _on_new_round() -> void:
	var star = powerup_scene.instantiate() as Powerup
	star.type = Powerup.Type.INVINCIBILITY
	
	add_child(star)
