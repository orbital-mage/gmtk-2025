class_name Clone extends CharacterBody2D

static var bullet_scene = preload("res://clones/bullet.tscn")

signal died(clone: Clone)
signal shoot(bullet: Bullet)

var rng = RandomNumberGenerator.new()
var replaying := false
var position_record: Array[Vector2] = []
var shoot_record: Dictionary = {}
var aim_record: Array[Vector2] = []
var index := 0
var dead := false

@export var speed: float = 800

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var sprite_color: AnimatedSprite2D = $Sprite/Color
@onready var dust_particles: GPUParticles2D = $DustParticles
@onready var gun_pivot: Node2D = $Pivot
@onready var gun_sprite: Sprite2D = $Pivot/Gun

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
	sprite_color.modulate = Color.from_hsv(randf(), 1, 1)

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	if not replaying:
		_player_movement()
	else:
		_recorded_movement()
	
	if velocity.length() > 1:
		sprite.play("run")
		sprite_color.play("run_color")
		dust_particles.emitting = true
	else:
		sprite.play("idle")
		sprite_color.play("idle_color")
		dust_particles.emitting = false
	
	var normVel: Vector2 = velocity / speed

	sprite.rotation_degrees = lerp(sprite.rotation_degrees, normVel.x * 10, 0.5)
	sprite.scale = sprite.scale.lerp(Vector2(normVel.y * 0.2 + 1, -normVel.y * 0.1 + 1), 0.5)

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
	velocity = vector * speed
	move_and_slide()
	
	var mouse_pos :Vector2 = get_global_mouse_position()
	aim_record.append(mouse_pos)
	face_towards(mouse_pos)
	position_record.append(position)

func face_towards(target: Vector2):
	var direction = (target - global_position).normalized()
	if target.x > global_position.x:
		sprite.flip_h = false
		sprite_color.flip_h = false
		gun_sprite.flip_v = false
	else:
		sprite.flip_h = true
		sprite_color.flip_h = true
		gun_sprite.flip_v = true
	var horizontal_factor = abs(direction.x)
	var distance_multiplier = lerp(0.5, 1.0, horizontal_factor)
	gun_sprite.position.x = 50 * distance_multiplier
	gun_pivot.look_at(target)

func _recorded_movement() -> void:
	position = position_record[index]
	face_towards(aim_record[index])
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
