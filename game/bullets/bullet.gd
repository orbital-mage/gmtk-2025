class_name Bullet extends Node2D

static var scene = preload("res://game/bullets/bullet.tscn")

static func create(pos: Vector2, dir: Vector2, src: Clone) -> Bullet:
	var bullet = scene.instantiate() as Bullet
	
	bullet.position = pos
	bullet.direction = dir
	bullet.source = src
	
	return bullet

@export var speed: float = 2000

var source: Clone
var direction: Vector2
var custom_color: Color
var custom_process: Callable

@onready var sprite: Sprite2D = $Sprite
@onready var shadow_sprite: Sprite2D = $Shadow
@onready var hitbox: BulletHitbox = $Hitbox

func _ready() -> void:
	update_direction()
	
	if custom_color:
		sprite.modulate = custom_color

func set_color(color: Color) -> void:
	custom_color = color

func update_direction() -> void:
	sprite.rotation = direction.angle()
	shadow_sprite.rotation = direction.angle()

func set_custom_process(callable: Callable) -> void:
	custom_process = callable

func _physics_process(delta: float) -> void:
	if custom_process:
		update_direction()
		custom_process.call(self, delta)
	else:
		position += direction * delta * speed

func _exit_tree() -> void:
	get_parent().add_child.call_deferred(BulletDestroyEffect.create(self))

func _on_lifetime_timeout() -> void:
	queue_free()

func _on_hit(area: Area2D) -> void:
	if is_queued_for_deletion():
		return
	
	if area is CloneHitbox:
		if area.clone == source:
			return
		
		if area.clone.invincible:
			direction *= -1
			source = area.clone
			return
		
		area.clone.bullet_hit(self)
	
	queue_free()

func _on_hit_body(body: Node2D) -> void:
	if body is StaticBody2D:
		queue_free()
