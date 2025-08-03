extends Node

static var clone_scene = preload("res://game/clones/clone.tscn")
static var items = load("res://ui/shop/item_table.tres")

signal coins_changed
signal item_changed

var clone: Clone
var coins := 0
var item: ItemResource = items.items[6]

func reset() -> void:
	clone = null
	coins = 0
	item = null

func new_clone() -> Clone:
	clone = clone_scene.instantiate()
	return clone

func set_item(new: ItemResource) -> void:
	item = new
	item_changed.emit()

func take_item() -> ItemResource:
	var tmp = item
	item = null
	item_changed.emit()
	return tmp

func add_coin() -> void:
	coins += 1
	coins_changed.emit()

func pay(amount: int) -> void:
	coins -= amount
	coins_changed.emit()
