extends Camera2D

@export var clone: Clone

func _process(delta: float) -> void:
	if enabled:
		var diff = clone.get_global_mouse_position() - clone.global_position
		
		var distance = diff.length()
		
		var strength = min(pow(distance / 1000, 1), 0.5)
		
		position = lerp(Vector2.ZERO, get_local_mouse_position(), strength)
