extends Path2D

@onready var enemies = {
		"enemy_jet" : {"spawnable" : false, "scene" : preload("res://Scenes/enemy_jet.tscn"), "weight" : 100},
		"blue_drone" : {"spawnable" : false, "scene" : preload("res://Scenes/blue_drone.tscn"), "weight" : 50},
		"red_drone" : {"spawnable" : false,"scene" : preload("res://Scenes/red_drone.tscn"), "weight" : 50},
		"red_plane" : {"spawnable": true, "scene" : preload("res://Scenes/red_plane.tscn"), "weight" : 25}
}
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	$spawn_timer.wait_time = 4
	_spawn_wave()

func _on_spawn_timer_timeout() -> void:
	_spawn_wave()

func _calculate_total_weights():
	var total_weight = 0

	for enemy in enemies.values():
		if enemy["spawnable"]:
			total_weight += enemy["weight"]
	
	return total_weight

func _make_spawnable(enemy_name):
	enemies[enemy_name]["spawnable"] = true

func _update_weights():
	var total_weight = _calculate_total_weights()
	var num_of_enemies = enemies.size()
	var avg_weight = total_weight / num_of_enemies
	
	for enemy in enemies.values():
		if enemy["weight"] <= avg_weight:
			#Weight to spawn strong enemies increases by .5
			enemy["weight"] += (enemy["weight"] * 0.5)
		else:
			#Weight to spawn weak enemies decrease by .2
			enemy["weight"] -= (enemy["weight"] * 0.2)

func _select_enemy():
	var total_weight = _calculate_total_weights()

	var random_weight = rng.randi_range(0, total_weight - 1)
	for enemy_name in enemies.keys():
		if enemies[enemy_name]["spawnable"]:
			random_weight -= enemies[enemy_name]["weight"]
			if random_weight < 0:
				return enemy_name

func _spawn_n_enemies(spawn_count):
	var spawn_locations = []
	var enemy_name = _select_enemy()
	var enemy_scene = enemies[enemy_name]["scene"]

	for i in range(spawn_count):
		var enemy_texture
		var spawn_attempts = 0
		var valid_pos = false
		var enemy = enemy_scene.instantiate()

		#grab enemy texture size
		if enemy.has_node("animation"):
			enemy_texture = enemy.get_node("animation").get_sprite_frames().get_frame_texture("idle", 0)
		else:
			enemy_texture = enemy.get_node("sprite").get_texture()
		var spawn_location = $spawner_path

		#Check if there is already enemy spawned at this position		
		while !valid_pos and spawn_attempts < 10:
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

func _spawn_wave():
	var spawn_count = rng.randi_range(3, 5)
	_spawn_n_enemies(spawn_count)
	$spawn_timer.start()