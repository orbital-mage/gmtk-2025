extends Node2D

static var clone_scene = preload("res://clones/clone.tscn")
static var rng = RandomNumberGenerator.new()

var clones: Array[Clone] = []
var player_clone: Clone
var prev_time := 1

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start()
	
	_new_clone()

func _on_timeout() -> void:
	timer.wait_time += prev_time
	prev_time = timer.wait_time - prev_time
	
	_replay()

func _on_clone_died(clone: Clone) -> void:
	if clone == player_clone:
		_replay()
	else:
		remove_child(clone)

func _on_shoot(bullet: Bullet) -> void:
	add_child(bullet)

func _replay() -> void:
	clones.append(player_clone)
	_new_clone()
	for clone in clones:
		remove_child(clone)
		add_child(clone)
		clone.replay()
	
	timer.start()

func _new_clone() -> void:
	player_clone = clone_scene.instantiate() as Clone
	add_child(player_clone)
	var viewport_size = get_viewport_rect().size
	player_clone.position = Vector2(rng.randf_range(0, viewport_size.x), rng.randf_range(0, viewport_size.y))
	
	player_clone.died.connect(_on_clone_died)
	player_clone.shoot.connect(_on_shoot)
