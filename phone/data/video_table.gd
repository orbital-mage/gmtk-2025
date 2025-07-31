class_name VideoTable extends Resource

static var rng = RandomNumberGenerator.new()
static var tables = [
	load("res://phone/data/jumpscare_table.tres"),
	load("res://phone/data/talking_table.tres")
]

static func randomize() -> VideoData:
	var table = _random_item(tables) as Resource
	
	var data = VideoData.new()
	data.content = _random_item(table.content)
	data.audio = _random_item(table.audio)
	data.title = _random_item(table.titles)
	data.description = _random_item(table.descriptions)
	
	return data

static func _random_item(arr: Array) -> Variant:
	return arr[rng.randi_range(0, arr.size() - 1)]

@export var content: Array[PackedScene] = []
@export var audio: Array[VideoText] = []
@export var titles: Array[String] = []
@export var descriptions: Array[String] = []
