extends Node2D

static var powerup_scene = preload("res://game/powerups/powerup.tscn")

@export var randomize := false

func _ready() -> void:
	Arena.new_round.connect(_on_new_round)

func _on_new_round() -> void:
	if randomize:
		_set_powerup(Powerup.random())
		return
	
	var star = powerup_scene.instantiate() as Powerup
	star.type = Powerup.Type.INVINCIBILITY
	
	_set_powerup(star)

func _set_powerup(powerup: Powerup) -> void:
	if powerup.get_parent():
		powerup.get_parent().remove_child.call_deferred(powerup)
	
	add_child.call_deferred(powerup)
