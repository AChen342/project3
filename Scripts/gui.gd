extends Control

var score = 0
var new_score = 0
signal update_score(s)
signal shake_pilot
signal pilot_death
var player_death = false
@onready var scoreLabel = $score
@onready var death_profile = preload("res://Sprites/pilot_dead.png")

func _process(delta: float) -> void:
	if score < new_score:
		score += 5
		scoreLabel.set_text("Score: %d" % score)

	if player_death:
		$pilot.texture = death_profile

func _on_update_score(s:int) -> void:
	new_score = s

func _shake_pilot_profile():
	$pilot.get_node("AnimationTree").play("shake")

func _on_player_death():
	player_death = true