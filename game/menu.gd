extends Control

@onready var test_sound: AudioStreamPlayer = $TestSound

func _ready() -> void:
	set_volume(0.7)

func set_volume(value: float):
	AudioServer.set_bus_volume_db(0, lerp(-70.0, 20.0, value))
	test_sound.play()

func start():
	get_tree().change_scene_to_file("res://game/arena.tscn")
