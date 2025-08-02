class_name CloneSounds extends Node2D

@onready var steps: AudioStreamPlayer2D = $Steps
@onready var shoot: AudioStreamPlayer2D = $Shoot

func play_step() -> void:
	if !steps.playing:
		steps.play()

func play_shoot() -> void:
	shoot.play()
