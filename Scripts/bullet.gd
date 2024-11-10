extends Area2D

@export var speed = 1000
@export var damage = 5

var direction : Vector2
var screen_size : Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size

func set_direction(bulletDirection):
	direction = bulletDirection
	rotation_degrees = rad_to_deg(global_position.angle_to_point(global_position + direction))	

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	
func _process(delta: float) -> void:
	if global_position.y > screen_size.y + $bullet_sprite.texture.get_size().y:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
	
	queue_free()
