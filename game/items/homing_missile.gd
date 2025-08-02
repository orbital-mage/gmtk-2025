class_name HomingMissile extends Item

func use(clone: Clone, target: Vector2) -> void:
	var bullet_pos = clone.gun.get_barrel_position()
	var direction = (target - bullet_pos).normalized()
	var missile = Bullet.create(bullet_pos, direction, clone)
	
	missile.speed = 1200
	missile.scale = Vector2.ONE * 1.5
	missile.set_color(Color.RED)
	missile.set_custom_process(_bullet_process)
	
	clone.shoot.emit(missile)

func _bullet_process(bullet: Bullet, delta: float) -> void:
	var target_clone: Clone
	var value := -9999.0
	
	for clone: Clone in bullet.get_tree().get_nodes_in_group("clones"):
		if clone == bullet.source:
			continue
		
		var diff = clone.position - bullet.position
		var hit_direction = diff.normalized()
		var dot = bullet.direction.dot(hit_direction)
		var weight = dot + 0.5
		var distance = diff.length()
		
		if weight / distance > value:
			value = weight / distance
			target_clone = clone
	
	if target_clone:
		var curr_angle = bullet.direction.angle()
		var target_angle = (target_clone.position - bullet.position).angle()
		var new_angle = curr_angle + delta * 4 * sign((target_angle - curr_angle))
		
		bullet.direction = Vector2.from_angle(new_angle)
	
	bullet.position += bullet.direction * delta * bullet.speed
