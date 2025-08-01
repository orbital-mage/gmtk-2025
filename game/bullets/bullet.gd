class_name Bullet extends Node2D

@export var speed: float = 2000

var direction: Vector2
var released := false

@onready var sprite: Sprite2D = $Sprite
@onready var shadow_sprite: Sprite2D = $Shadow
@onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
	sprite.rotation = direction.angle()
	shadow_sprite.rotation = direction.angle()

func set_target(target: Vector2):
	direction = (target - position).normalized()

func set_direction(value: Vector2):
	direction = value

func _physics_process(delta: float) -> void:
	position += direction * delta * speed

func _on_lifetime_timeout() -> void:
	queue_free()

func _on_released(area: Area2D) -> void:
	released = true
	hitbox.set_collision_layer_value(Collision.Layers.BULLETS, true)

func _on_hit(area: Area2D) -> void:
	if released:
		queue_free()
