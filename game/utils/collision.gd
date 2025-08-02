class_name Collision extends Node

enum Layers { 
	CLONES = 1,
	POWERUPS = 2,
	ZOMBIES = 3,
	BULLETS = 4,
	BOUNDS = 9,
	ENVIRONMENT = 10
}

static func create_mask(values: Array[int]) -> int:
	var obj = StaticBody2D.new()
	obj.collision_mask = 0
	
	for value in values:
		obj.set_collision_mask_value(value, true)
	
	return obj.collision_mask
