extends Node2D

static var clone_scene = preload("res://clones/clone.tscn")

const arena_size = 1200

var clones: Array[Clone] = []
var player_clone: Clone
var prev_time := 1

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start()
	
	_new_clone()

func _on_timeout() -> void:
	_replay()

func _on_clone_died(clone: Clone) -> void:
	if clone == player_clone:
		_replay()
	else:
		remove_child.call_deferred(clone)
		
		if _is_player_alone():
			timer.start()

func _on_shoot(bullet: Bullet) -> void:
	add_child(bullet)

func _replay() -> void:
	timer.stop()
	clones.append(player_clone)
	_new_clone()
	for clone in clones:
		if not clone.get_parent():
			add_child.call_deferred(clone)
		clone.replay()

func _new_clone() -> void:
	player_clone = clone_scene.instantiate() as Clone
	add_child.call_deferred(player_clone)
	
	player_clone.position = Vector2.from_angle(randf_range(0, 2 * PI)) * arena_size
	
	player_clone.died.connect(_on_clone_died)
	player_clone.shoot.connect(_on_shoot)

func _is_player_alone() -> bool:
	for clone in clones:
		if not clone.dead:
			return false
	
	return true
