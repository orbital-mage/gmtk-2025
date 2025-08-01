extends Node2D

const arena_size = 1200

var clones: Array[Clone] = []
var bullets: Array[Bullet] = []
var player_clone: Clone
var living_clones := 0

@onready var world: Node2D = $World
@onready var round_timer: Timer = $RoundTimer

func _ready() -> void:
	round_timer.start()
	Arena.new_round.emit()
	
	_new_clone()

func _on_round_timeout() -> void:
	_finish_round()

func _on_clone_died(clone: Clone) -> void:
	if clone == player_clone:
		_finish_round()
	else:
		living_clones -= 1
		_clones_changed()
		world.remove_child.call_deferred(clone)
		
		if _is_player_alone():
			round_timer.start()

func _on_shoot(bullet: Bullet) -> void:
	bullets.append(bullet)
	world.add_child(bullet)

func _finish_round() -> void:
	round_timer.stop()
	clones.append(player_clone)
	_clear_bullets()
	
	_replay()

func _replay() -> void:
	Arena.new_round.emit()
	living_clones = clones.size()
	_clones_changed()
	
	_new_clone()
	
	for clone in clones:
		if not clone.get_parent():
			world.add_child.call_deferred(clone)
		clone.replay()

func _new_clone() -> void:
	player_clone = Player.new_clone()
	world.add_child.call_deferred(player_clone)
	
	player_clone.position = _random_direction() * arena_size
	
	player_clone.died.connect(_on_clone_died)
	player_clone.shoot.connect(_on_shoot)

func _clear_bullets() -> void:
	for bullet in bullets:
		if bullet:
			bullet.queue_free()
	
	bullets.clear()

func _is_player_alone() -> bool:
	for clone in clones:
		if not clone.dead:
			return false
	
	return true

func _random_direction() -> Vector2:
	return Vector2.from_angle(randf_range(0, 2 * PI))

func _clones_changed() -> void:
	Arena.clones_changed.emit(clones.size(), living_clones)
