extends Enemy

var bullet_scene = preload("res://Scenes/bullet.tscn")

func _ready() -> void:
	$twin_guns/cooldown.wait_time = 4
	health = 30
	speed = 70

func shoot():
	var bullet1 = bullet_scene.instantiate()
	var bullet2 = bullet_scene.instantiate()

	bullet1.global_position = $twin_guns/gun1.global_position
	bullet2.global_position = $twin_guns/gun2.global_position

	bullet1.add_to_group("enemy_projectile")
	bullet2.add_to_group("enemy_projectile")

	get_parent().add_child(bullet1)
	get_parent().add_child(bullet2)

	bullet1.set_direction(Vector2(0, 1))
	bullet2.set_direction(Vector2(0, 1))

func _physics_process(delta: float) -> void:
	movement(delta)
	on_collision(delta)
	
	if $twin_guns/cooldown.is_stopped():
		shoot()
		$twin_guns/cooldown.start()

func _on_cooldown_timeout() -> void:
	shoot()
