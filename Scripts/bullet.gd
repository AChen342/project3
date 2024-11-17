extends Area2D

var speed = 500
var damage = 5
var direction : Vector2
@onready var sharpnel = preload("res://Scenes/sharpnel.tscn")
@onready var screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

	if global_position.y > screen_size.y + $bullet_sprite.texture.get_size().y:
		_on_destroy()

func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("enemies") and not is_in_group("enemy_projectile"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		_on_destroy()
	
	elif body.is_in_group("player") and is_in_group("enemy_projectile"):
		if body.has_method("player_damage"):
			body.player_damage(5)
		_on_destroy()
			

func _on_destroy():
	var bulletSharpnel = sharpnel.instantiate()
	bulletSharpnel.global_position = global_position
	get_parent().add_child(bulletSharpnel)
	queue_free()

func set_direction(bulletDirection):
	direction = bulletDirection
	rotation_degrees = rad_to_deg(global_position.angle_to_point(global_position + direction))	