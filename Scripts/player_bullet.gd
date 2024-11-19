extends Bullet

func _ready() -> void:
	$animation.play("idle")

func _physics_process(delta: float) -> void:
	global_position += direction * speed * (delta/Engine.time_scale)

	if global_position.y > screen_size.y + texture.get_size().y:
		_on_destroy()