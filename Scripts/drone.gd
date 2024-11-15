extends Enemy

class_name Drone

var frequency : float
var amplitude : float
var time : float

func _ready() -> void:
	frequency = 1
	amplitude = 200
	time = 0
	health = 5
	speed = 10
	collision_damage = 5
	$animation.play("idle")
	$animation.rotation_degrees = -90
	
func movement(delta):
	time += speed * delta
	var offset_x = amplitude * sin(frequency * time)
	
	position.x += (offset_x * delta)
	position.y += 1
