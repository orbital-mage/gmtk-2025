extends Node2D

func _draw() -> void:
	draw_circle(Vector2.ZERO, 10, Color.WHITE, false, 4)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		position = event.position
