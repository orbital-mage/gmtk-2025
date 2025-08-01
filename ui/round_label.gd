extends Label

func _ready() -> void:
	Game.new_round.connect(_on_new_round)

func _on_new_round() -> void:
	text = "%s / 5" % ((Game.round_number - 1) % 5 + 1)
