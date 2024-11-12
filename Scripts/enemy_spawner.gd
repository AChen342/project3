extends Path2D

var enemies : Dictionary

func _ready() -> void:
	$spawn_timer.wait_time = 3
	enemies = {
		"enemy_jet" : preload("res://Scenes/enemy_jet.tscn"),
		"blue_drone": preload("res://Scenes/blue_drone.tscn"),
		"red_drone": preload("res://Scenes/red_drone.tscn"),
		"red_plane": preload("res://Scenes/red_plane.tscn")
	}
	$spawn_timer.start()
	spawn_enemies()
	
func spawn_enemies():
	var new_enemy = (enemies.get("red_plane")).instantiate()
	var spawn_location = $spawner_path
	spawn_location.progress_ratio = randf()
	new_enemy.position = spawn_location.position
	new_enemy.set_direction(Vector2(0, 1))
	get_parent().add_child(new_enemy)
	$spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	spawn_enemies()