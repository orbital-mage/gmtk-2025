extends Node2D

const arena_size = 1500

var clones: Array[Clone] = []
var disposables: Array[Node2D] = []
var player_clone: Clone
var living_clones := 0
var in_shop := false
var round_started := true

@onready var world: Node2D = $Environment
@onready var round_end_timer: Timer = $RoundEndTimer
@onready var round_start_timer: Timer = $RoundStartTimer
@onready var screen_fade: ScreenFade = $UI/Fade
@onready var round_start_sound: AudioStreamPlayer = $RoundStartSound

@export var first_spawn_time: float
@export var stagger_spawn_time: float

func _ready() -> void:
	Arena.leave_shop.connect(func(): 
		round_start_timer.wait_time = first_spawn_time
		round_start_timer.start()
		in_shop = false
	)
	Arena.add_effect.connect(_add_disposable)
	
	round_end_timer.start()
	Arena.new_round.emit()
	
	_new_clone()
	player_clone.rise()

func _on_round_start_timeout() -> void:
	if not round_started:
		round_started = true
		round_start_timer.wait_time = stagger_spawn_time
		
	for clone in clones:
		if clone.sleeping:
			clone.rise()
			round_start_timer.start()
			return
	
	player_clone.rise()
	round_start_sound.play()

func _on_round_end_timeout() -> void:
	round_end_timer.wait_time = 0.5
	_finish_round()

func _on_fade_finished() -> void:
	if screen_fade.is_black:
		_reset_arena()
		if not _go_to_shop():
			screen_fade.fade_out()
	elif not in_shop:
		round_start_timer.wait_time = first_spawn_time
		round_start_timer.start()

func _on_clone_died(clone: Clone) -> void:
	if clone == player_clone:
		clone.hide()
		_add_disposable(DeathEffect.create(clone))
		
		round_end_timer.start()
	else:
		living_clones -= 1
		_clones_changed()
		world.remove_child.call_deferred(clone)
		
		_add_disposable(DeathEffect.create(clone))
		
		if _is_player_alone():
			round_end_timer.start()

func _on_shoot(bullet: Bullet) -> void:
	_add_disposable(bullet)

func _finish_round() -> void:
	round_started = false
	round_end_timer.stop()
	
	screen_fade.fade_in()

func _reset_arena() -> void:
	_clear_disposables()
	_reset_clones()
	_new_clone()
	Arena.new_round.emit()

func _reset_clones() -> void:
	player_clone.unset_player()
	clones.append(player_clone)
	living_clones = clones.size()
	_clones_changed()
	
	for clone in clones:
		if not clone.get_parent():
			world.add_child.call_deferred(clone)
		clone.reset()

func _new_clone() -> void:
	player_clone = Player.new_clone()
	world.add_child.call_deferred(player_clone)
	
	player_clone.position = _random_position()
	
	player_clone.died.connect(_on_clone_died)
	player_clone.shoot.connect(_on_shoot)

func _go_to_shop() -> bool:
	#if clones.size() == 1:
		#in_shop = true
		#Arena.go_to_shop(1)
		#return true
	
	if clones.size() > 1 and (clones.size() - 1) % 5 == 0:
		in_shop = true
		Arena.go_to_shop(clones.size() - 1)
		return true
	
	return false

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

func _random_position() -> Vector2:
	return (Vector2.from_angle(randf_range(0, 2 * PI)) * 
		randi_range(arena_size / 2, arena_size))

func _clones_changed() -> void:
	Arena.clones_changed.emit(clones.size(), living_clones)
