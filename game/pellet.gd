extends Node2D

func _on_collected(area: Area2D) -> void:
	queue_free()
