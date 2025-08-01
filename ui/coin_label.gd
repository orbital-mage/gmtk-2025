extends Label

func _ready() -> void:
	Player.coins_changed.connect(_on_coins_changed)

func _on_coins_changed() -> void:
	text = "%s$" % Player.coins
