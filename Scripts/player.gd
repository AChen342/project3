extends CharacterBody2D

const SPEED = 300.0
const MAX_HEALTH = 100
const DEFAULT_COOLDOWN = .3
const SPECIAL_DURATION = 8
const BACKLASH_DURATION = 5
var screen_size
var health : float
var special_mode_on = false
var speed_modifier = 1
var is_invincible = false
signal special_mode
@onready var gui = get_parent().get_node("user_interface").get_node("gui")
@onready var explosion = preload("res://Scenes/effects/death_particle.tscn")
@onready var bullet_scene = preload("res://Scenes/player_bullet.tscn")
@onready var clock_scene = preload("res://Scenes/buffs/clock.tscn")
@onready var debuff_scene = preload("res://Scenes/debuff/debuff.tscn")
@onready var speed_lines = preload("res://Scenes/effects/speed_lines.tscn")

func _init() -> void:
	health = MAX_HEALTH

func _ready() -> void:
	screen_size = get_viewport_rect().size
	$animation.play("idle")
	$gun/cooldown.set_wait_time(DEFAULT_COOLDOWN)
	$gun/cooldown.start()
	$special_duration.set_wait_time(SPECIAL_DURATION)
	$backlash_duration.set_wait_time(BACKLASH_DURATION)

func _physics_process(delta: float) -> void:
	player_controls(delta)
	if health <= 0:
		on_destroy()

func _on_special_mode():
	special_mode_on = true

func on_destroy():
	var explode = explosion.instantiate()
	explode.global_position = global_position
	get_parent().add_child(explode)
	queue_free()

func player_controls(delta):
	player_movement(delta)
	player_special()

func player_shoot():
	create_bullet()
	$gun/cooldown.start()

func create_bullet():
	var new_bullet = bullet_scene.instantiate()
	new_bullet.global_position = $gun.global_position
	new_bullet.set_direction(Vector2(0, -1))
	get_parent().add_child(new_bullet)

#responsible for player special behaviour
func player_special():
	if Input.is_action_just_pressed("special") and special_mode_on:
		special_mode_on = false
		
		#clock buff indicator
		var clock = clock_scene.instantiate()
		clock.global_position = screen_size / 2
		
		gui.add_child(clock)

		# increase speed, make invincible, increase gun fire rate
		speed_modifier = 2
		is_invincible = true
		$gun/cooldown.set_wait_time(.1)

		# send signal to gui to reset special bar
		gui.emit_signal("reset_special_bar")

		#adds speed lines effect
		var speed_effect = speed_lines.instantiate()
		gui.add_child(speed_effect)

		#start special duration countdown
		$special_duration.start()

# occurs after player uses special
func _backlash():
	var debuff = debuff_scene.instantiate()
	add_child(debuff)

	speed_modifier = .2
	$gun/cooldown.set_wait_time(1)
	$backlash_duration.start()

	gui.emit_signal("tired_pilot")

#controls player sprite
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
		velocity = velocity.normalized() * (SPEED * speed_modifier)

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
	if not is_invincible:
		gui.emit_signal("shake_pilot")
		health -= damage
		gui.emit_signal("update_player_health", health)

func player_heal(heal_amount):
	var new_health = health + heal_amount
	if new_health > MAX_HEALTH:
		health = MAX_HEALTH
	else:
		health = new_health
	
	gui.emit_signal("update_player_health", health)

func _on_special_duration_timeout() -> void:
	var clock = gui.get_node_or_null("clock")
	var speed_effect = gui.get_node_or_null("speed_lines")

	if clock != null:
		gui.get_node("clock").queue_free()

	if speed_effect != null:
		gui.get_node("speed_lines").queue_free()

	is_invincible = false
	gui.emit_signal("start_charging_special")
	_backlash()

func _start_backlash_timer() -> void:
	var debuff = get_node_or_null("debuff")
	if debuff != null:
		debuff.queue_free()

	speed_modifier = 1
	$gun/cooldown.set_wait_time(DEFAULT_COOLDOWN)
