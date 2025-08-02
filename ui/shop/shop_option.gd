class_name ShopOption extends Control

static var scene = preload("res://ui/shop/shop_option.tscn")
static var item_table: ItemTable = load("res://ui/shop/item_table.tres")

static func create(round_number: int, item: ItemResource) -> ShopOption:
	var option = scene.instantiate() as ShopOption
	
	option.item = item
	option.price = int(option.item.base_price * round_number)
	
	return option
	

@export var item: ItemResource
@export var price: int

@onready var name_label: Label = $Name
@onready var price_label: Label = $Price
@onready var button: Button = $Button

func _ready() -> void:
	if item:
		name_label.text = item.name
		button.icon = item.texture
	
	price_label.text = "- %s$" % price

func _on_button_pressed() -> void:
	if item:
		Player.set_item(item)
	
	Player.pay(price)
	Arena.back_to_game()
