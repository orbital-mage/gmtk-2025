class_name VideoContent extends Node2D

signal clip_finished

@export var player: AnimationPlayer

var animation: String

func _ready() -> void:
	animation = player.current_animation
	player.stop()
	
	player.animation_finished.connect(_on_animation_finished)

func play():
	player.stop()
	player.play(animation)

func pause():
	player.stop()

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == animation:
		clip_finished.emit()
