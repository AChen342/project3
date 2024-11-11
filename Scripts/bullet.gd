extends Area2D

@export var speed = 1000
@export var damage = 5

var sharpnel : PackedScene
var direction : Vector2
var screen_size : Vector2

func _ready() -> void:
	sharpnel = preload("res://Scenes/sharpnel.tscn")
	screen_size = get_viewport_rect().size

func set_direction(bulletDirection):
	direction = bulletDirection
	rotation_degrees = rad_to_deg(global_position.angle_to_point(global_position + direction))	

func on_destroy():
	var bulletSharpnel = sharpnel.instantiate()
	bulletSharpnel.global_position = global_position
	get_parent().add_child(bulletSharpnel)
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

	if global_position.y > screen_size.y + $bullet_sprite.texture.get_size().y:
		on_destroy()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)

	
	on_destroy()
