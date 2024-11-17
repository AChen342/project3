extends Enemy

func _ready() -> void:
	health = 10
	speed = 100
	$animation.play("idle")
	rotation_degrees =  90

