extends ColorRect

func _ready() -> void:
	Arena.shop.connect(_on_shop)
	Arena.resume.connect(_on_resume)

func _on_shop() -> void:
	show()

func _on_resume() -> void:
	hide()
