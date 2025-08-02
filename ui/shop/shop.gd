extends Control

static var item_table: ItemTable = load("res://ui/shop/item_table.tres")

@onready var shelf: HBoxContainer = $MarginContainer/Shelf

func _ready() -> void:
	Arena.shop.connect(_on_open)
	Arena.leave_shop.connect(_on_close)

func _on_open(round_number: int) -> void:
	show()
	
	for i in range(3):
		shelf.add_child(ShopOption.create(round_number, _random_item()))

func _on_close() -> void:
	hide()
	
	for option in shelf.get_children():
		shelf.remove_child(option)

func _random_item() -> ItemResource:
	var item = item_table.items[randi_range(0, item_table.items.size() - 1)]
	
	for option: ShopOption in shelf.get_children():
		if option.item == item:
			return _random_item()
	
	return item
