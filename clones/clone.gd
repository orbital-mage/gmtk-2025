class_name Clone extends CharacterBody2D

static var bullet_scene = preload("res://clones/bullet.tscn")

signal died(clone: Clone)
signal shoot(bullet: Bullet)

var dead := false
var replaying := false
var aim_target: Vector2
var color: Color

var index := 0
var velocity_record: Array[Vector2] = []
var aim_record: Array[Vector2] = []
var shoot_record: Dictionary = {}

@export var speed: float = 800

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var sprite_color: AnimatedSprite2D = $Sprite/Color
@onready var dust_particles: GPUParticles2D = $DustParticles
@onready var gun_pivot: Node2D = $Pivot
@onready var gun_sprite: Sprite2D = $Pivot/Gun
@onready var hitbox: Area2D = $Hitbox
@onready var camera: Camera2D = $Camera2D

func replay() -> void:
	dead = false
	index = 0
	_unset_player()
	_set_zombiefied(false)

func _ready() -> void:
	velocity_record.append(Vector2.ZERO)
	aim_record.append(get_global_mouse_position())
	
	color = Color.from_hsv(
		randf(), randf_range(0.8, 1), randf_range(0.6, 0.8))
	sprite_color.modulate = color

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	if not replaying:
		_player_movement()
	elif index < velocity_record.size():
		_recorded_movement()
	else:
		_zombie_movement()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("replay"):
		replay()
	
	if not replaying and event.is_action_pressed("shoot"):
		shoot_record.set(velocity_record.size(), get_global_mouse_position())
		_shoot(get_global_mouse_position())

func _on_hit(area: Area2D) -> void:
	dead = true
	died.emit(self)

func _player_movement() -> void:
	var vector = Input.get_vector("left", "right", "up", "down")
	velocity = vector * speed
	move_and_slide()
	
	aim_target = get_global_mouse_position()
	
	aim_record.append(aim_target)
	velocity_record.append(velocity)

func _recorded_movement() -> void:
	velocity = velocity_record[index]
	aim_target = aim_record[index]
	index += 1
	
	move_and_slide()
	
	if shoot_record.has(index):
		_shoot(shoot_record[index])
	
	if index == velocity_record.size():
		_set_zombiefied(true)

func _zombie_movement() -> void:
	var player = get_tree().get_first_node_in_group("player") as Clone
	
	velocity = (player.position - position).normalized() * speed
	
	move_and_slide()

func _shoot(taget: Vector2) -> void:
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.position = position
	bullet.set_target(taget)
	shoot.emit(bullet)

func _unset_player() -> void:
	replaying = true
	camera.enabled = false
	remove_from_group("player")

func _set_zombiefied(zombified: bool) -> void:
	hitbox.set_collision_layer_value(2, zombified)
	
	if zombified:
		sprite_color.modulate = Color.BLACK
		gun_pivot.hide()
	else:
		sprite_color.modulate = color
		gun_pivot.show()
