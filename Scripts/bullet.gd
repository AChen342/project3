class_name Bullet
extends Area2D

var speed : float
var damage : float
var rng : RandomNumberGenerator
var direction : Vector2
@onready var sharpnel = preload("res://Scenes/effects/sharpnel.tscn")
@onready var screen_size = get_viewport_rect().size
@onready var texture = $animation.get_sprite_frames().get_frame_texture("idle", 0)

func _init() -> void:
	speed = 500
	damage = 5
	rng = RandomNumberGenerator.new()

func _ready() -> void:
	var random_time = rng.randf_range(2, 4)
	$animation.play("idle")
	$lifetime.wait_time = random_time
	$lifetime.start()
	
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

	if global_position.y > screen_size.y + texture.get_size().y:
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

# enemy bullets destroy themselves after a period of time
func _on_lifetime_timeout() -> void:
	_on_destroy()

func _on_destroy():
	var bulletSharpnel = sharpnel.instantiate()
	bulletSharpnel.global_position = global_position
	get_parent().add_child(bulletSharpnel)
	queue_free()

# below functions are called by objects (such as enemies and player objects)
func set_direction(bulletDirection):
	direction = bulletDirection
	rotation_degrees = rad_to_deg(global_position.angle_to_point(global_position + direction))

func set_speed(new_speed):
	speed = new_speed