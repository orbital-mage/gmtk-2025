extends Control

@onready var shelf: HBoxContainer = $MarginContainer/Shelf

func _ready() -> void:
	Arena.shop.connect(_on_open)
	Arena.resume.connect(_on_close)

func _on_open() -> void:
	show()
	
	shelf.add_child(ShopOption.cheap_drink())
	
	for i in range(3):
		shelf.add_child(ShopOption.random_item())

func _on_close() -> void:
	hide()
	
	for option in shelf.get_children():
		shelf.remove_child(option)

func _on_pay_pressed() -> void:
	Player.pay(5)
	Arena.back_to_game()
