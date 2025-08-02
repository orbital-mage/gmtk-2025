class_name Bullet extends Node2D

@export var speed: float = 2000

var source: Clone
var direction: Vector2

@onready var sprite: Sprite2D = $Sprite
@onready var shadow_sprite: Sprite2D = $Shadow
@onready var hitbox: BulletHitbox = $Hitbox

func _ready() -> void:
	sprite.rotation = direction.angle()
	shadow_sprite.rotation = direction.angle()

func set_target(target: Vector2):
	direction = (target - position).normalized()

func set_direction(value: Vector2):
	direction = value

func set_source(clone: Clone):
	source = clone

func _physics_process(delta: float) -> void:
	position += direction * delta * speed

func _on_lifetime_timeout() -> void:
	queue_free()

func _on_hit(area: Area2D) -> void:
	if area is CloneHitbox:
		if area.clone == source:
			return
		
		if area.clone.invincible:
			direction *= -1
			set_source(area.clone)
			return
	
	queue_free()

func _on_hit_body(body: Node2D) -> void:
	if body is StaticBody2D:
		queue_free()
