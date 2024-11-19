class_name Enemy
extends CharacterBody2D

var speed: float
var health: float
var direction: Vector2
var x_direction : float
var rng = RandomNumberGenerator.new()
var points = 100
var collision_damage = 10
@onready var explosion_animation = preload("res://Scenes/explosion.tscn")
@onready var collectible_list = {
	"health_pack" : preload("res://Scenes/collectibles/health_pack.tscn")
}
@onready var screen_size = get_viewport_rect().size

func _init() -> void:
	x_direction = 0

func _process(delta: float) -> void:
	var texture_size = _get_texture_size()

	if health <= 0:
		get_parent().emit_signal("add_points", points)
		_on_destroy()

	# Prevents enemy from going off screen in x axis
	position.x = clamp(position.x, texture_size.x, screen_size.x - texture_size.x)
	# destroy enemy if off screen in y axis
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
	global_position.x += x_direction * speed * delta

func _on_destroy():
	# generate explosion effect
	var explode = explosion_animation.instantiate()
	explode.global_position = global_position
	get_parent().add_child(explode)

	#drop health pack
	var roll_item = rng.randf_range(0, 1)
	if roll_item <= .1:
		var health_pack = collectible_list["health_pack"].instantiate()
		health_pack.global_position = global_position
		get_parent().add_child(health_pack)

	# free enemy
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