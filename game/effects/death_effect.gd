class_name DeathEffect extends Node2D

static var scene = preload("res://game/effects/death.tscn")

static func create(clone: Clone) -> DeathEffect:
	var effect = scene.instantiate() as DeathEffect
	
	effect.position = clone.position
	effect.set_color(clone.get_color())
	effect.player = clone == Player.clone
	
	return effect

var color: Color
var player: bool

@export var colored: Array[CanvasItem]

@onready var player_sound: AudioStreamPlayer2D = $PlayerHitSound
@onready var enemy_sound: AudioStreamPlayer2D = $EnemyHitSound

func _ready() -> void:
	for item: CanvasItem in colored:
		item.modulate = color
	
	if player:
		player_sound.play()
	else:
		enemy_sound.play()

func set_color(value: Color) -> void:
	color = value
