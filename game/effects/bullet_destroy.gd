class_name BulletDestroyEffect extends Node2D

static var scene = preload("res://game/effects/bullet_destroy.tscn")

static func create(bullet: Bullet) -> BulletDestroyEffect:
	var effect = scene.instantiate() as BulletDestroyEffect
	
	effect.position = bullet.position
	
	return effect

func _on_animation_finished(anim_name: StringName) -> void:
	queue_free()
