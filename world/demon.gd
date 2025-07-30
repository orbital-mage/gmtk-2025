extends Node2D

@export var player: Node2D

func _physics_process(delta: float) -> void:
	position = position.move_toward(player.position, delta * 100)
