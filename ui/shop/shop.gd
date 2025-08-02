extends MarginContainer

@onready var shelf: HBoxContainer = $VBoxContainer/Shelf

func _ready() -> void:
	Arena.shop.connect(_on_open)

func _on_open() -> void:
	for option in shelf.get_children():
		shelf.remove_child(option)
	
	shelf.add_child(ShopOption.cheap_drink())
	
	for i in range(3):
		shelf.add_child(ShopOption.random_item())

func _on_pay_pressed() -> void:
	Player.pay(5)
	Arena.back_to_game()
