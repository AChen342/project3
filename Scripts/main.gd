extends Node2D

signal add_points(points)
const MAX_ENEMY_TYPES = 4
var difficulty = 0
var increase_difficulty_interval = 1500
var unlock_new_enemy_interval = 1000
var total_points = 0
var num_enemies_unlocked = 0
var all_enemies_unlocked = false
@onready var spawner = get_node("enemy_spawner")
@onready var user_interface = get_node("user_interface")
	
func _on_add_points(points:int) -> void:
	total_points += points
	user_interface.get_node("gui").emit_signal("update_score", total_points)
	
	#increase difficulty and unlock new enemy if enough points
	_check_difficulty()
	_unlock_new_enemy()

func _unlock_new_enemy():
	var points_to_enemy_unlock = floor(float(total_points)/unlock_new_enemy_interval)

	# unlocks a new enemy type for every 1000 points
	if (not all_enemies_unlocked) and (points_to_enemy_unlock > num_enemies_unlocked):
		num_enemies_unlocked += 1
		unlock_new_enemy_interval += 500
		match num_enemies_unlocked:
			1:
				spawner.emit_signal("unlock_new_enemy", "blue_drone")
			2:
				spawner.emit_signal("unlock_new_enemy", "red_drone")
			3:
				spawner.emit_signal("unlock_new_enemy", "red_plane")
			
			MAX_ENEMY_TYPES:
				all_enemies_unlocked = true

func _check_difficulty():
	var points_to_difficulty = floor(float(total_points)/increase_difficulty_interval)
	
	# increases difficulty every 1500 points
	if points_to_difficulty > difficulty:
		difficulty += 1
		spawner.emit_signal("update_weights")