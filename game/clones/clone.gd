class_name Clone extends CharacterBody2D

signal died(clone: Clone)
signal shoot(bullet: Bullet)

var dead := false
var replaying := false
var zombified := false
var invincible := false
var aim_target: Vector2

var index := 0
var start_position: Vector2
var velocity_record: Array[Vector2] = []
var aim_record: Array[Vector2] = []
var shoot_record: Dictionary = {}
var item_record: Dictionary = {}

@export var speed: float = 800

@onready var animations: CloneAnimations = $Animations
@onready var gun: CloneGun = $Gun
@onready var hitbox: Area2D = $Hitbox
@onready var camera: Camera2D = $Camera2D
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var sounds: CloneSounds = $Sounds

var drink_effect: PackedScene = preload("res://game/effects/drink_use.tscn")

func unset_player() -> void:
	replaying = true
	camera.enabled = false
	hitbox.set_collision_mask_value(Collision.Layers.ZOMBIES, false)

func reset() -> void:
	show()
	dead = false
	zombified = false
	invincible = false
	hitbox.set_collision_layer_value(Collision.Layers.STARS, false)
	index = 0
	position = start_position
	velocity = Vector2.ZERO
	aim_target = aim_record[0]
	_set_zombified(false)

func bullet_hit(bullet: Bullet) -> void:
	if dead:
		return
	
	if replaying and not zombified and bullet.source == Player.clone:
		Player.add_coin()
		Arena.add_effect.emit(CoinEffect.create(self, 1))
		_die()
	else:
		_die()

func is_replay_finished() -> bool:
	return index == velocity_record.size() and not velocity_record.is_empty()

func get_color() -> Color:
	return animations.get_color()

func _ready() -> void:
	start_position = position
	
	animations.set_color(Color.from_hsv(
		randf(), randf_range(0.8, 1), randf_range(0.6, 0.8)))
	animations.reset()

func _physics_process(_delta: float) -> void:
	if dead or Arena.paused:
		if not replaying:
			aim_target = get_global_mouse_position()
		return
	
	if not replaying:
		_player_movement()
	elif index < velocity_record.size():
		_recorded_movement()
	elif zombified:
		_zombie_movement()

func _input(event: InputEvent) -> void:
	if dead or Arena.paused:
		return
	
	if not replaying and event.is_action_pressed("shoot"):
		shoot_record.set(velocity_record.size(), get_global_mouse_position())
		_shoot(get_global_mouse_position())
	
	if not replaying and event.is_action_pressed("use_item") and Player.item:
		var item = Player.take_item()
		item_record.set(velocity_record.size(), item)
		_use_item(item, get_global_mouse_position())

func _on_hit(area: Area2D) -> void:
	if dead:
		return
	
	if area is CloneHitbox:
		if replaying and not zombified and area.clone == Player.clone:
			Player.add_coin()
			Arena.add_effect.emit(CoinEffect.create(self, 1))
		
		_zombie_hit(area.clone)
	elif area is PowerupHitbox:
		_powerup_get(area.powerup)

func _zombie_hit(_clone: Clone) -> void:
	if invincible:
		return
	
	_die()

func _powerup_get(powerup: Powerup) -> void:
	match powerup.type:
		Powerup.Type.INVINCIBILITY:
			invincible = true
			invincibility_timer.start()
			sounds.play_powerup()
			hitbox.set_collision_layer_value(Collision.Layers.STARS, true)

func _die() -> void:
	if not replaying:
		Player.pay(1)
		Arena.add_effect.emit(CoinEffect.create(self, -1))
	
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
	
	if item_record.has(index):
		_use_item(item_record[index], aim_target)
	
	if index == velocity_record.size():
		_set_zombified(true)

func _zombie_movement() -> void:
	var nearest_decoy: Node2D
	var min_dist := 999999
	
	for decoy: Node2D in get_tree().get_nodes_in_group("decoy"):
		var distance = (position - decoy.position).length()
		if distance < min_dist:
			nearest_decoy = decoy
			min_dist = distance
	
	var target: Vector2
	
	if nearest_decoy:
		target = nearest_decoy.position
	else:
		target = Player.clone.position
	
	velocity = (target - position).normalized() * speed * 1.2
	
	move_and_slide()

func _shoot(target: Vector2) -> void:
	var bullet_pos = gun.get_barrel_position()
	var direction = (target - bullet_pos).normalized()
	var bullet = Bullet.create(bullet_pos, direction, self)
	shoot.emit(bullet)
	sounds.play_shoot(not replaying)
	gun.shoot_anim()

func _use_item(item: ItemResource, target: Vector2) -> void:
	item.item.new().use(self, target)
	
	animations.drink(item.color)
	gun.drink()

func _set_zombified(value: bool) -> void:
	hitbox.set_collision_layer_value(Collision.Layers.ZOMBIES, value)
	hitbox.set_collision_mask_value(Collision.Layers.POWERUPS, not value)
	
	if value:
		animations.zombify()
	else:
		animations.reset()
		zombified = false

func _on_sprite_animation_finished() -> void:
	if is_replay_finished() and not zombified:
		zombified = true

func _on_invincibility_timeout() -> void:
	invincible = false
	hitbox.set_collision_layer_value(Collision.Layers.STARS, false)
