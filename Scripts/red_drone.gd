extends Drone

var follow_player_flag = false
var explosion_animation = preload("res://Scenes/explosion.tscn")

func _physics_process(delta: float) -> void:
    if follow_player_flag:
        follow_player(delta)
    else:
        movement(delta)

    var collision = move_and_collide(velocity * delta)
    if collision:
        var explode = explosion_animation.instantiate()
        explode.global_position = global_position
        get_parent().add_child(explode)
        queue_free()

func follow_player(delta):
    var player_pos = get_parent().get_node("Player").position
    var target_pos = (player_pos - position).normalized()
    position += target_pos * (speed * 10) * delta

func _on_detection_body_entered(body:Node2D) -> void:
    if body.is_in_group("player"):
        follow_player_flag = true

func _on_detection_body_exited(body:Node2D) -> void:
    if body.is_in_group("player"):
        follow_player_flag = false