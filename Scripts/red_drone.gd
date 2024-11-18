extends Drone

var follow_player_flag = false

func _physics_process(delta: float) -> void:
    _movement(delta)
    _on_collision(delta)

func _movement(delta):
    var player_pos = get_parent().get_node("Player").position
    var target_pos = (player_pos - position).normalized()
    position += target_pos * (speed * 20) * delta