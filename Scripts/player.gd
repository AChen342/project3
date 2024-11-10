extends CharacterBody2D
const SPEED = 300.0
var screen_size
@export var bullet_scene : PackedScene

func _ready() -> void:
	screen_size = get_viewport_rect().size
	$animation.play("idle")
	$gun/cooldown.set_wait_time(.5)

func _physics_process(delta: float) -> void:
	player_controls(delta)

func player_controls(delta):
	player_movement(delta)
	player_shoot()

func player_shoot():
	if Input.is_action_pressed("shoot") and $gun/cooldown.is_stopped():
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
	var texture = $animation.get_frame()
	position.x = clamp(position.x, 32, screen_size.x - 32)
	position.y = clamp(position.y, screen_size.y / 2, screen_size.y - 50)
	
func _on_cooldown_timeout() -> void:
	if Input.is_action_pressed("shoot"):
		create_bullet()