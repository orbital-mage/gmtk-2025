extends Control

@onready var shelf: HBoxContainer = $MarginContainer/Shelf

func _ready() -> void:
	Arena.shop.connect(_on_open)
	Arena.resume.connect(_on_close)

func _on_open(round_number: int) -> void:
	show()
	
	for i in range(3):
		shelf.add_child(ShopOption.random_item(round_number))

func _on_close() -> void:
	hide()
	
	for option in shelf.get_children():
		shelf.remove_child(option)
