extends Node

var attention := 100.0
var snooze_rate := 10

func focus() -> void:
	attention += 10
	attention = min(attention, 100)

func snooze(delta: float) -> void:
	attention -= snooze_rate * delta
	attention = max(attention, 0)
	
	if attention == 0:
		print('sleepy!!!')
