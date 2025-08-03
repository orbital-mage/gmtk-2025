class_name Nuke extends Node2D

static var scene = preload("res://game/items/nuke.tscn")

static func create(clone: Clone) -> Nuke:
	var nuke = scene.instantiate() as Nuke
	
	nuke.user = clone
	
	return nuke

var user: Clone
var windup: NukeWindupEffect

func _ready() -> void:
	user.died.connect(_on_user_died)
	
	windup = NukeWindupEffect.create(user)
	Arena.add_effect.emit(windup)

func _on_user_died(_clone: Clone) -> void:
	if windup:
		windup.queue_free()
	queue_free()

func _on_windup_timeout() -> void:
	pass

func _on_timeout() -> void:
	if user.dead:
		windup.queue_free()
		queue_free()
		return
	
	Arena.add_effect.emit(NukeEffect.create())
	
	for clone: Clone in get_tree().get_nodes_in_group("clones"):
		clone.die(user)
