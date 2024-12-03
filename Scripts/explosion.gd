extends AnimatedSprite2D


@onready var particle = preload("res://Scenes/effects/death_particle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("explode")
	var particle_effect = particle.instantiate()
	particle_effect.global_position = global_position
	get_parent().add_child(particle_effect)

func _on_animation_finished() -> void:
	queue_free()