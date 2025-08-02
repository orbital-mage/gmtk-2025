class_name ShopOption extends Control

static var scene = preload("res://ui/shop/shop_option.tscn")
static var item_table: ItemTable = load("res://ui/shop/item_table.tres")

static func cheap_drink(round: int) -> ShopOption:
	var option = scene.instantiate() as ShopOption
	
	option.price = int(round * 0.4)
	
	return option

static func random_item(round: int) -> ShopOption:
	var option = scene.instantiate() as ShopOption
	
	option.item = item_table.items[randi_range(0, item_table.items.size() - 1)]
	option.price = int(option.item.base_price * round)
	
	return option
	

@export var item: ItemResource
@export var price: int

@onready var name_label: Label = $Name
@onready var price_label: Label = $Price
@onready var button: Button = $Button

func _ready() -> void:
	if item:
		name_label.text = item.name
	
	price_label.text = "- %s$" % price

func _on_button_pressed() -> void:
	if item:
		Player.set_item(item)
	
	Player.pay(price)
	Arena.back_to_game()
