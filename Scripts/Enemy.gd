class_name Enemy
extends CharacterBody2D

var speed: float
var health: float
var direction: Vector2
var points = 100
var collision_damage = 10
@onready var explosion_animation = preload("res://Scenes/explosion.tscn")
@onready var screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	var texture_size = _get_texture_size()

	if health <= 0:
		get_parent().emit_signal("add_points", points)
		_on_destroy()
	
	if position.y >= (screen_size.y + texture_size.y):
		queue_free()
	
func _physics_process(delta: float) -> void:
	_movement(delta)
	_on_collision(delta)

func set_direction(enemyDirection):
	direction = enemyDirection
	rotation_degrees = rad_to_deg(global_position.angle_to_point(global_position + enemyDirection))
	
func take_damage(damage):
	health -= damage

# default movement for enemies
func _movement(delta):
	global_position += direction * speed * delta

func _on_destroy():
	var explode = explosion_animation.instantiate()
	explode.global_position = global_position
	get_parent().add_child(explode)
	queue_free()

func _on_collision(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		var body = collision.get_collider()
		if body.is_in_group("player"):
			if body.has_method("player_damage"):
				body.player_damage(collision_damage)
			_on_destroy()

func _get_texture_size():
	var texture
	if has_node("animation"):
		texture = $animation.get_sprite_frames().get_frame_texture("idle", 0)
		return texture.get_size()
	elif has_node("sprite"):
		texture = $sprite.get_texture()
		return texture.get_size()
	else:
		print_debug("Enemy object missing texture (missing sprite or animation node)")