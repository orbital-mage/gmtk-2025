extends Node2D

static var clone_scene = preload("res://game/clones/clone.tscn")
static var pellet_scene = preload("res://game/pellet.tscn")

const arena_size = 1200

var clones: Array[Clone] = []
var player_clone: Clone
var prev_time := 1

@onready var replay_timer: Timer = $ReplayTimer
@onready var powerup_timer: Timer = $PowerupTimer

func _ready() -> void:
	replay_timer.start()
	_randomize_powerup_time()
	
	_new_clone()

func _on_replay_timeout() -> void:
	_replay()

func _on_powerup_timeout() -> void:
	var pellet = pellet_scene.instantiate() as Node2D
	pellet.position = _random_direction() * arena_size * randf()
	add_child(pellet)
	_randomize_powerup_time()

func _on_clone_died(clone: Clone) -> void:
	if clone == player_clone:
		_replay()
	else:
		remove_child.call_deferred(clone)
		
		if _is_player_alone():
			replay_timer.start()

func _on_shoot(bullet: Bullet) -> void:
	add_child(bullet)

func _replay() -> void:
	replay_timer.stop()
	clones.append(player_clone)
	_new_clone()
	for clone in clones:
		if not clone.get_parent():
			add_child.call_deferred(clone)
		clone.replay()

func _new_clone() -> void:
	player_clone = clone_scene.instantiate() as Clone
	add_child.call_deferred(player_clone)
	
	player_clone.position = _random_direction() * arena_size
	
	player_clone.died.connect(_on_clone_died)
	player_clone.shoot.connect(_on_shoot)

func _is_player_alone() -> bool:
	for clone in clones:
		if not clone.dead:
			return false
	
	return true

func _randomize_powerup_time() -> void:
	powerup_timer.wait_time = randi_range(8, 32)

func _random_direction() -> Vector2:
	return Vector2.from_angle(randf_range(0, 2 * PI))
