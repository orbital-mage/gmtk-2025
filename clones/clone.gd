class_name Clone extends CharacterBody2D

static var bullet_scene = preload("res://clones/bullet.tscn")

signal died(clone: Clone)
signal shoot(bullet: Bullet)

var rng = RandomNumberGenerator.new()
var replaying := false
var aim_target: Vector2
var position_record: Array[Vector2] = []
var aim_record: Array[Vector2] = []
var shoot_record: Dictionary = {}
var index := 0
var dead := false

@export var speed: float = 800

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var sprite_color: AnimatedSprite2D = $Sprite/Color
@onready var dust_particles: GPUParticles2D = $DustParticles
@onready var gun_pivot: Node2D = $Pivot
@onready var gun_sprite: Sprite2D = $Pivot/Gun
@onready var camera: Camera2D = $Camera2D

func replay() -> void:
	show()
	replaying = true
	dead = false
	index = 0
	camera.enabled = false
	remove_from_group("player")

func die() -> void:
	hide()
	dead = true
	died.emit(self)

func _ready() -> void:
	position_record.append(position)
	aim_record.append(get_global_mouse_position())
	
	sprite_color.modulate = Color.from_hsv(
		randf(), randf_range(0.8, 1), randf_range(0.6, 0.8))

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	if not replaying:
		_player_movement()
	elif index < position_record.size():
		_recorded_movement()
	else:
		_zombie_movement()

func _on_hit(area: Area2D) -> void:
	die()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("replay"):
		replay()
	
	if not replaying and event.is_action_pressed("shoot"):
		shoot_record.set(position_record.size(), get_global_mouse_position())
		_shoot(get_global_mouse_position())

func _player_movement() -> void:
	var vector = Input.get_vector("left", "right", "up", "down")
	velocity = vector * speed
	move_and_slide()
	
	aim_target = get_global_mouse_position()
	
	aim_record.append(aim_target)
	position_record.append(position)

func _recorded_movement() -> void:
	position = position_record[index]
	aim_target = aim_record[index]
	index += 1
	
	if shoot_record.has(index):
		_shoot(shoot_record[index])

func _zombie_movement() -> void:
	var player = get_tree().get_first_node_in_group("player") as Clone
	
	velocity = (player.position - position).normalized() * speed
	
	move_and_slide()

func _shoot(taget: Vector2) -> void:
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.position = position
	bullet.set_target(taget)
	shoot.emit(bullet)
