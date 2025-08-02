class_name BulletDestroyEffect extends Node2D

static var scene = preload("res://game/effects/bullet_destroy.tscn")

static func create(bullet: Bullet) -> BulletDestroyEffect:
	var effect = scene.instantiate() as BulletDestroyEffect
	
	effect.position = bullet.position
	effect.data = bullet.data
	
	return effect

var data: BulletResource

@onready var discard: GPUParticles2D = $Discard

func _ready() -> void:
	discard.texture = data.texture

func _on_animation_finished(_anim_name: StringName) -> void:
	queue_free()
