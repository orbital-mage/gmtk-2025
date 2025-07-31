class_name Clone extends CharacterBody2D

static var bullet_scene = preload("res://clones/bullet.tscn")

signal died(clone: Clone)
signal shoot(bullet: Bullet)

var rng = RandomNumberGenerator.new()
var replaying := false
var position_record: Array[Vector2] = []
var shoot_record: Dictionary = {}
var index := 0
var dead := false

func replay() -> void:
	show()
	replaying = true
	dead = false
	index = 0

func die() -> void:
	hide()
	dead = true
	died.emit(self)

func _ready() -> void:
	modulate = Color(rng.randf(), rng.randf(), rng.randf(), 1)

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	if not replaying:
		_player_movement()
	else:
		_recorded_movement()

func _on_hit(area: Area2D) -> void:
	die()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("replay"):
		replay()
	
	if not replaying and event.is_action_pressed("shoot"):
		shoot_record.set(position_record.size(), event.position)
		_shoot(event.position)

func _player_movement() -> void:
	var vector = Input.get_vector("left", "right", "up", "down")
	velocity = vector * 800
	move_and_slide()
	
	position_record.append(position)

func _recorded_movement() -> void:
	position = position_record[index]
	index += 1
	
	if shoot_record.has(index):
		_shoot(shoot_record[index])
	
	if index == position_record.size():
		die()

func _shoot(taget: Vector2) -> void:
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.position = position
	bullet.set_target(taget)
	shoot.emit(bullet)
