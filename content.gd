class_name VideoContent extends Node2D

@export var animation_players: Array[AnimationPlayer]

func play():
	for anim: AnimationPlayer in animation_players:
		var current_anim: String = anim.current_animation
		anim.stop(true)
		anim.play(current_anim)
