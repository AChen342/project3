extends CharacterBody2D

class_name Enemy

var speed: float
var health: float
var direction: Vector2
var explosion_animation = preload("res://Scenes/explosion.tscn")
@onready var screen_size = get_viewport_rect().size

func set_direction(enemyDirection):
	direction = enemyDirection
	rotation_degrees = rad_to_deg(global_position.angle_to_point(-(global_position + enemyDirection)))

func movement(delta):
	global_position += direction * speed * delta
	
func take_damage(damage):
	health -= damage
	
func _process(delta: float) -> void:
	if health <= 0:
		on_destroy()
		

	var texture_size = $animation.get_sprite_frames().get_frame_texture("idle", 0).get_size()
	if position.y >= (screen_size.y + texture_size.y):
		queue_free()

func on_destroy():
	var explode = explosion_animation.instantiate()
	explode.global_position = global_position
	get_parent().add_child(explode)
	queue_free()


func _physics_process(delta: float) -> void:
	movement(delta)


