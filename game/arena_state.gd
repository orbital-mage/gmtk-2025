extends Node

signal clones_changed(total: int, living: int)
signal new_round
signal shop(round: int)
signal resume

func go_to_shop(round: int) -> void:
	shop.emit(round)
	get_tree().paused = true

func back_to_game() -> void:
	resume.emit()
	get_tree().paused = false
