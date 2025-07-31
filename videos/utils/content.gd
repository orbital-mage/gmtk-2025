class_name VideoContent extends Node2D

var players: Array[AnimationPlayer]

func _ready() -> void:
	for player: AnimationPlayer in find_children("*", "AnimationPlayer"):
		players.append(player)
		player.stop()

func play():
	for player: AnimationPlayer in players:
		var current_anim: String = player.current_animation
		player.stop()
		player.play(current_anim)

func pause():
	for player: AnimationPlayer in players:
		player.stop()
