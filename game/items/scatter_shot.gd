class_name ScatterShot extends Item

static var spike_data = load("res://game/bullets/spike_bullet.tres")

const spray_count = 16

func use(clone: Clone, _target: Vector2) -> void:
	for i in range(spray_count):
		var angle = i * (2 * PI / spray_count)
		
		var bullet = Bullet.create(clone.position, 
			Vector2.from_angle(angle), 
			clone)
		bullet.set_data(spike_data)

		clone.shoot.emit(bullet)
