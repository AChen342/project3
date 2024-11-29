extends Node2D

const CHAIN_SIZE = 10
const SPEED = 100
var screen_size = get_viewport_rect().size
var rand_speed_mult = 1
var center_points = []
var left_points = []
var right_points = []
var angles = []
var radius_lst = []
var stop = false
var rng = RandomNumberGenerator.new()
var target = Vector2(100, 100)
@onready var line = $Line2D

const DISTANCE = 10

func _ready():
	radius_lst.resize(CHAIN_SIZE)
	center_points.resize(CHAIN_SIZE)
	center_points[0] = get_viewport().get_mouse_position()
	
	for i in range(1, center_points.size()):
		center_points[i] = center_points[i - 1] + Vector2(100, 100)
	
	update_line()
	

func _physics_process(delta) -> void:
	fabrik()
	update_line()
	_movement(delta)


func _draw() -> void:
	draw_body()

func _movement(delta):
	var target_pos = (target - center_points[0]).normalized()
	center_points[0] += target_pos * (SPEED * rand_speed_mult) * delta

	if center_points[0].distance_to(target) < 50:
		target = Vector2(rng.randf_range(50, 650), rng.randf_range(50, 430))

func _follow_mouse(delta):
	var mouse_position = get_viewport().get_mouse_position()
	while (center_points[0].distance_to(mouse_position) > 50):
		var target_pos = (mouse_position - center_points[0]).normalized()
		center_points[0] += target_pos * (SPEED * rand_speed_mult) * delta

func fabrik():
	#forward pass, aligns each point to the point behind~
	for i in range(1, center_points.size()):
		center_points[i] = constrain_distance(center_points[i], center_points[i - 1], DISTANCE)

	#backward pass, aligns each point to the point in front
	for i in range(center_points.size() - 1, 0):
		center_points[i] = constrain_distance(center_points[i], center_points[i + 1], DISTANCE)

func constrain_distance(point: Vector2, anchor: Vector2, distance: float) -> Vector2:
	return (point - anchor).normalized() * distance + anchor

func update_line():
	line.clear_points()

	for i in range (center_points.size()):
		line.add_point(center_points[i])
	queue_redraw()


func draw_sides(degree:float, color:Color, left:bool):
	var temp = []

	for i in range(center_points.size()):
		var radius = radius_lst[i]
		var side = Vector2(
			center_points[i].x + cos(deg_to_rad(degree)) * radius,
			center_points[i].y + sin(deg_to_rad(degree)) * radius
		)
		temp.insert(i, side)
	
	if left:
		left_points = temp
	else:
		right_points = temp
	
	for i in range(temp.size() - 1):
		draw_line(temp[i], temp[i + 1], color, 2)
	
#visual
func draw_body():
	var radius = 25
	var temp = []

	#outline
	for i in range(line.points.size()):
		#stores radius of circle
		temp.insert(i, radius)
		draw_circle(center_points[i], radius, Color.LIGHT_BLUE)
	
		radius -= log(radius) / 2
	radius_lst = temp

	draw_sides(0, Color.RED, false) 
	draw_sides(180, Color.BLUE, true)
