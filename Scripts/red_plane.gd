extends Enemy

@onready var bullet_scene = preload("res://Scenes/bullet.tscn")

func _ready() -> void:
	points = 500
	$twin_guns/cooldown.wait_time = 4
	health = 30
	speed = 70
	collision_damage = 15

func _physics_process(delta: float) -> void:
	_movement(delta)
	_on_collision(delta)
	
	if $twin_guns/cooldown.is_stopped():
		_shoot()
		$twin_guns/cooldown.start()

func _on_cooldown_timeout() -> void:
	_shoot()

func _shoot():
	var twin_guns = [
		$twin_guns/gun1,
		$twin_guns/gun2
	]
	
	var rand_x = rng.randf_range(-0.5, 1)
	var rand_speed = rng.randf_range(100, 200)

	for gun in twin_guns:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = gun.global_position
		
		if bullet.has_method("set_speed"):
			bullet.set_speed(rand_speed)
		
		bullet.add_to_group("enemy_projectile")
		get_parent().add_child(bullet)
		bullet.set_direction(Vector2(rand_x, 1))