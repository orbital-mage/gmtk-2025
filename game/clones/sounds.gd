class_name CloneSounds extends Node2D

@onready var steps: AudioStreamPlayer2D = $Steps
@onready var shoot: AudioStreamPlayer2D = $Shoot
@onready var player_shoot: AudioStreamPlayer2D = $PlayerShoot
@onready var spawn: AudioStreamPlayer2D = $Spawn
@onready var zombify: AudioStreamPlayer2D = $Zombify
@onready var powerup: AudioStreamPlayer2D = $Powerup

func play_step() -> void:
	if !steps.playing:
		steps.play()

func play_shoot(player: bool) -> void:
	if player:
		player_shoot.play()
	else:
		shoot.play()

func play_spawn() -> void:
	spawn.play()

func play_zombify() -> void:
	zombify.play()

func play_powerup() -> void:
	powerup.play()
