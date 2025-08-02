class_name ShopOption extends VBoxContainer

static var scene = preload("res://ui/shop/shop_option.tscn")
static var item_table: ItemTable = load("res://ui/shop/item_table.tres")

static func cheap_drink() -> ShopOption:
	var option = scene.instantiate() as ShopOption
	
	option.item_name = "Cheap Drink"
	option.price = 2
	
	return option

static func random_item() -> ShopOption:
	var option = scene.instantiate() as ShopOption
	
	var table = load("res://ui/shop/item_table.tres")
	var resource = item_table.items[randi_range(0, item_table.items.size() - 1)]
	option.item = resource.item.new()
	option.item_name = resource.name
	option.price = 5
	
	return option

@export var item: Item
@export var item_name: String
@export var price: int

@onready var label: Label = $Label
@onready var button: Button = $Button

func _ready() -> void:
	label.text = item_name
	button.text = "- %s$" % price

func _on_button_pressed() -> void:
	if item:
		Player.add_item(item)
	
	Player.pay(price)
	Arena.back_to_game()
