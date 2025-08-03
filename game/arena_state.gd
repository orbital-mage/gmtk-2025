extends Node

signal clones_changed(total: int, living: int)
signal new_round
signal shop(round: int)
signal leave_shop
signal add_effect(effect: Node2D)

var paused := false

func reset() -> void:
	paused = false

func go_to_shop(round_number: int) -> void:
	shop.emit(round_number)
	get_tree().paused = true

func back_to_game() -> void:
	leave_shop.emit()
	get_tree().paused = false
