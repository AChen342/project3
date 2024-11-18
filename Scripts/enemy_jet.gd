extends Enemy

func _init() -> void:
	health = 10
	speed = 100

#when enemy_jet node is ready
func _ready() -> void:
	$animation.play("idle")
	$wanderTimer.start()
	rotation_degrees = 90

func _on_wander_timer_timeout() -> void:
	#randomize x - axis movement
	var rand_x = rng.randf_range(-1, 1)
	x_direction = rand_x

	#randomize speed
	var rand_speed = rng.randf_range(50, 100)
	speed = rand_speed