class_name Shop extends Control

static var item_table: ItemTable = load("res://ui/shop/item_table.tres")

@onready var shelf: HBoxContainer = $HBoxContainer/NinePatchRect/Margin/Shelf
@onready var text: RichTextLabel = $HBoxContainer/NinePatchRect/Margin/Text/Label
@onready var buy_sound: AudioStreamPlayer = $BuySound

func _ready() -> void:
	Arena.shop.connect(_on_open)
	Arena.leave_shop.connect(_on_close)
	
	set_text("")

func _on_open(round_number: int) -> void:
	show()
	modulate = Color.WHITE
	$"../Fade".fade_out()
	
	for i in range(3):
		var option: ShopOption = ShopOption.create(round_number, _random_item())
		shelf.add_child(option)
		option.button.mouse_entered.connect(hover_start.bind(option))
		option.button.mouse_exited.connect(hover_end.bind(option))

func _on_close() -> void:
	buy_sound.play()
	
	var t: Tween = create_tween()
	t.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	t.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	t.tween_callback(hide)
	
	for option in shelf.get_children():
		shelf.remove_child(option)

func _random_item() -> ItemResource:
	var item = item_table.items[randi_range(0, item_table.items.size() - 1)]
	
	for option: ShopOption in shelf.get_children():
		if option.item == item:
			return _random_item()
	return item

func set_text(string: String = ""):
	if string == "":
		text.text = "Buy a drink or get lost..."
	else:
		text.text = string

func hover_start(option: ShopOption):
	var string: String = "[color=#{color}]{name}[/color]? That'll be [color=yellow]{cost}$[/color]...\n\n{desc}"
	string = string.format({
		"name" : option.item.name, 
		"cost" : option.price, 
		"desc" : option.item.description,
		"color" : option.item.color.to_html()})
	set_text(string)
	option.animation.stop()
	option.animation.play("select")

func hover_end(option: ShopOption):
	set_text()
	option.animation.stop()
	option.animation.play("unselect")

func _on_quit() -> void:
	print("quit")
