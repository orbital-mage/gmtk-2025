class_name ScreenFade extends ColorRect

signal fade_finished

var is_black := false

func fade_in() -> void:
	is_black = true

func fade_out() -> void:
	is_black = false

func _process(_delta: float) -> void:
	if is_black and color.a != 1.0:
		color.a = lerp(color.a, 1.0, 0.05)
		
		if round(color.a * 1000) == 1000:
			color.a = 1
			fade_finished.emit()
	elif not is_black and color.a != 0.0:
		color.a = lerp(color.a, 0.0, 0.1)
		
		if round(color.a * 1000) == 0:
			color.a = 0
			fade_finished.emit()
