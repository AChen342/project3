extends Path2D

var enemies : Dictionary
var rng

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	$spawn_timer.wait_time = 4
	enemies = {
		"enemy_jet" : preload("res://Scenes/enemy_jet.tscn"),
		"blue_drone": preload("res://Scenes/blue_drone.tscn"),
		"red_drone": preload("res://Scenes/red_drone.tscn"),
		"red_plane": preload("res://Scenes/red_plane.tscn")
	}
	spawn_wave()

func spawn_n_enemies(spawn_count):
	var spawn_locations = []
	
	for i in range(spawn_count):
		var enemy_texture
		var spawn_attempts = 0
		var valid_pos = false
		var enemy = (enemies.get("red_plane")).instantiate()
		if enemy.has_node("animation"):
			enemy_texture = enemy.get_node("animation").get_sprite_frames().get_frame_texture("idle", 0)
		else:
			enemy_texture = enemy.get_node("sprite").get_texture()
		var spawn_location = $spawner_path

		#Check if there is already enemy spawned at this position		
		while !valid_pos and spawn_attempts < 4:
			spawn_location.progress_ratio = randf()
			valid_pos = true	
			for pos in spawn_locations:
				if pos.distance_to(spawn_location.position) < (2.5 * enemy_texture.get_size().x):
					valid_pos = false
					break
			spawn_attempts += 1
		
		if valid_pos:
			enemy.set_direction(Vector2(0, 1))
			enemy.position = spawn_location.position
		
			spawn_locations.append(enemy.global_position)
			get_parent().add_child.call_deferred(enemy)

func spawn_wave():
	var spawn_count = rng.randi_range(1, 5)
	spawn_n_enemies(spawn_count)
	$spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	spawn_wave()