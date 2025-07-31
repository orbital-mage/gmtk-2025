extends Node2D

@export var animation_players: Array[AnimationPlayer]

func play():
	for anim: AnimationPlayer in animation_players:
		anim.stop(true)
