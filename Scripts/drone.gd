class_name Drone
extends Enemy

var frequency : float
var amplitude : float
var time : float
var rotate_texture : float
var y_speed : float

func _init() -> void:
	points = 50
	frequency = rng.randf_range(.5, 1)
	amplitude = rng.randi_range(100, 200)
	time = 0
	health = 5
	rotate_texture = 270
	speed = 5
	collision_damage = 5
	y_speed = rng.randi_range(1, 2)

func _ready() -> void:
	$animation.play("idle")
	$animation.rotation_degrees = rotate_texture
	
func _movement(delta):
	time += speed * delta
	var offset_x = amplitude * sin(frequency * time)
	
	position.x += (offset_x * delta)
	position.y += y_speed
