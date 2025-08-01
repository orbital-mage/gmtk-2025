extends Node

signal clones_changed(total: int, living: int)
signal new_round
signal shop
signal resume

func go_to_shop() -> void:
	shop.emit()
	get_tree().paused = true

func back_to_game() -> void:
	resume.emit()
	get_tree().paused = false
