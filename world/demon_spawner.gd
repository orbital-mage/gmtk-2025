extends Node

var demon_scene = preload("res://world/demon.tscn")
var rng = RandomNumberGenerator.new()

@export var world: Node2D
@export var player: Node2D

func spawn() -> void:
	var demon = demon_scene.instantiate() as Demon
	demon.player = player
	
	world.add_child(demon)
	
	var angle = rng.randf() * 2 * PI
	demon.position = Vector2.from_angle(angle) * 400 + player.position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn"):
		spawn()
