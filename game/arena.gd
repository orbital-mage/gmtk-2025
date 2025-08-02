extends Node2D

const arena_size = 800

var clones: Array[Clone] = []
var disposables: Array[Node2D] = []
var player_clone: Clone
var living_clones := 0

@onready var world: Node2D = $World
@onready var round_timer: Timer = $RoundTimer
@onready var pause_overlay: Control = $UI/PausedOverlay

func _ready() -> void:
	Arena.resume.connect(_replay)
	
	round_timer.start()
	Arena.new_round.emit()
	
	_new_clone()

func _on_round_timeout() -> void:
	_finish_round()

func _on_clone_died(clone: Clone, coin: bool) -> void:
	if clone == player_clone:
		_finish_round()
	else:
		living_clones -= 1
		_clones_changed()
		world.remove_child.call_deferred(clone)
		
		_add_disposable(DeathEffect.create(clone))
		
		if coin:
			_add_disposable(CoinEffect.create(clone))
		
		if _is_player_alone():
			round_timer.start()

func _on_shoot(bullet: Bullet) -> void:
	_add_disposable(bullet)

func _finish_round() -> void:
	round_timer.stop()
	clones.append(player_clone)
	_clear_disposables()
	
	if clones.size() > 1 and (clones.size() - 1) % 5 == 0:
		Arena.go_to_shop()
		return
	
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

func _add_disposable(node: Node2D) -> void:
	disposables.append(node)
	world.add_child.call_deferred(node)

func _clear_disposables() -> void:
	for node in disposables:
		if node:
			node.queue_free()
	
	disposables.clear()

func _is_player_alone() -> bool:
	for clone in clones:
		if not clone.dead:
			return false
	
	return true

func _random_direction() -> Vector2:
	return Vector2.from_angle(randf_range(0, 2 * PI))

func _clones_changed() -> void:
	Arena.clones_changed.emit(clones.size(), living_clones)
