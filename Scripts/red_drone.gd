extends Drone

var follow_player_flag = false
var rand_speed_mult = rng.randf_range(10, 20)

func _init() -> void:
	collision_damage = 20
	health = 10
	speed = 10
	rotate_texture = -90

func _physics_process(delta: float) -> void:
	_movement(delta)
	_on_collision(delta)

func _movement(delta):
	if get_parent().get_node_or_null("Player") == null:
		position += (Vector2(0, 1)) * (speed * rand_speed_mult) * delta
	else:
		var player_pos = get_parent().get_node("Player").position
		var target_pos = (player_pos - position).normalized()
		position += target_pos * (speed * rand_speed_mult) * delta
