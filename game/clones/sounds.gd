class_name CloneSounds extends Node2D

@onready var steps: AudioStreamPlayer2D = $Steps
@onready var shoot: AudioStreamPlayer2D = $Shoot
@onready var zombify: AudioStreamPlayer2D = $Zombify
@onready var powerup: AudioStreamPlayer2D = $Powerup

func play_step() -> void:
	if !steps.playing:
		steps.play()

func play_shoot() -> void:
	shoot.play()

func play_zombify() -> void:
	zombify.play()

func play_powerup() -> void:
	powerup.play()
