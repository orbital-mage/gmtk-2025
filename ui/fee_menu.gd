extends MarginContainer

func _on_pay_pressed() -> void:
	Player.pay(5)
	Arena.back_to_game()
