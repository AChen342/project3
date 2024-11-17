extends Node2D

signal add_points(points)
@onready var total_points = 0
@onready var user_interface = get_node("user_interface")

func _on_add_points(points:int) -> void:
	total_points += points
	user_interface.get_node("gui").emit_signal("update_score", total_points)