extends Node

var attention := 100.0
var snooze_rate := 20

func focus() -> void:
	attention += 20
	attention = min(attention, 100)

func snooze(delta: float) -> void:
	attention -= snooze_rate * delta
	attention = max(attention, 0)
	
	if attention == 0:
		print('sleepy!!!')
