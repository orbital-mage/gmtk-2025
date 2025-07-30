class_name Demon extends CharacterBody2D

@export var player: Node2D

@onready var sprite: Sprite2D = $Demon

func _physics_process(delta: float) -> void:
	if position.x - player.position.x > 0:
		sprite.flip_h = true
	
	position = position.move_toward(player.position, delta * 100)
