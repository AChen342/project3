extends Area2D

const SPEED = 50
const HEAL_AMOUNT = 20

func _process(delta: float) -> void:
	position.y += SPEED * delta

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		body.player_heal(HEAL_AMOUNT)
		queue_free()

func _on_onscreen_screen_exited() -> void:
	queue_free()
