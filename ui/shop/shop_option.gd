class_name ShopOption extends Control

static var scene = preload("res://ui/shop/shop_option.tscn")
static var item_table: ItemTable = load("res://ui/shop/item_table.tres")

static func create(round_number: int, item: ItemResource) -> ShopOption:
	var option = scene.instantiate() as ShopOption
	
	option.item = item
	var base_price = 2 + 3 * (round_number / 5 - 1)
	option.price = int(option.item.base_price * base_price)
	
	return option

@export var item: ItemResource
@export var price: int

@onready var button: Button = $Button
@onready var texture: TextureRect = $Button/Texture
@onready var animation: AnimationPlayer = $Animation
@onready var broke_sound: AudioStreamPlayer = $BrokeSound

func _ready() -> void:
	if item:
		button.icon = item.texture
		texture.texture = item.texture

func _on_button_pressed() -> void:
	if Player.coins < price:
		broke_sound.play()
		return
	
	if item:
		Player.set_item(item)
	
	Player.pay(price)
	Arena.back_to_game()
