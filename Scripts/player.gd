extends CharacterBody2D
const SPEED = 300.0
const MAX_HEALTH = 100
var screen_size
var health : float
@onready var gui = get_parent().get_node("user_interface").get_node("gui")
@onready var explosion = preload("res://Scenes/explosion.tscn")
@onready var bullet_scene = preload("res://Scenes/player_bullet.tscn")

func _init() -> void:
	health = MAX_HEALTH

func _ready() -> void:
	screen_size = get_viewport_rect().size
	$animation.play("idle")
	$gun/cooldown.set_wait_time(.3)
	$gun/cooldown.start()

func _physics_process(delta: float) -> void:
	Engine.time_scale = .2
	player_controls(delta / Engine.time_scale)
	if health <= 0:
		on_destroy()

func on_destroy():
	var explode = explosion.instantiate()
	explode.global_position = global_position
	explode.play()
	get_parent().add_child(explode)
	queue_free()

func player_controls(delta):
	player_movement(delta)

func player_shoot():
	create_bullet()
	$gun/cooldown.start()

func create_bullet():
	var new_bullet = bullet_scene.instantiate()
	new_bullet.global_position = $gun.global_position
	new_bullet.set_direction(Vector2(0, -1))
	get_parent().add_child(new_bullet)

func player_movement(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED

	if velocity.x < 0:
		$animation.flip_h = false
		$animation.animation = "move"
	elif velocity.x > 0:
		$animation.flip_h = true
		$animation.animation = "move"
	elif velocity.y > 0:
		$animation.animation = "down"
	elif velocity.y < 0:
		$animation.animation = "up"
	else:
		$animation.flip_h = false
		$animation.animation = "idle"
		
	position += velocity * delta
	
	# Makes sure sprite doesn't leave screen
	var texture_size = $animation.get_sprite_frames().get_frame_texture("idle", 0).get_size()
	position.x = clamp(position.x, texture_size.x, screen_size.x - texture_size.x)
	position.y = clamp(position.y, screen_size.y / 4, screen_size.y - texture_size.y)
	
func _on_cooldown_timeout() -> void:
	player_shoot()

func player_damage(damage):
	gui.emit_signal("shake_pilot")
	health -= damage
	gui.emit_signal("update_player_health", health)
	print_debug("Player health %d" % health)

func player_heal(heal_amount):
	var new_health = health + heal_amount
	if new_health > MAX_HEALTH:
		health = MAX_HEALTH
	else:
		health = new_health
	
	gui.emit_signal("update_player_health", health)
