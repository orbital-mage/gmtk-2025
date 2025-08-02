extends TextureRect

func _ready() -> void:
	Player.item_changed.connect(_on_item_changed)

func _on_item_changed() -> void:
	if Player.item:
		show()
		texture = Player.item.texture
	else:
		hide()
