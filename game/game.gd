extends Node

signal new_round

var round_number := 1

func next_round() -> void:
	round_number += 1
	new_round.emit()
