extends GPUParticles2D

func _ready() -> void:
	set_emitting(true)

func _on_finished() -> void:
	queue_free()
