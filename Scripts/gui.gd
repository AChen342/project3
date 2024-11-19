extends Control

var score = 0
var new_score = 0
const SPECIAL_RATE = .1
var special_rate_modifier = 1
signal update_score(s)
signal shake_pilot
signal update_player_health(health)
var player_death = false
@onready var scoreLabel = $score
@onready var death_profile = preload("res://Sprites/pilot_dead.png")
@onready var heal_effect = preload("res://Scenes/effects/heal_effect.tscn")

func _process(delta: float) -> void:
	if score < new_score:
		score += 5
		scoreLabel.set_text("Score: %d" % score)

	if (get_parent().get_parent().get_node_or_null("Player") == null):
		$pilot.texture = death_profile

	$special.value += SPECIAL_RATE * special_rate_modifier

func _on_update_score(s:int) -> void:
	new_score = s

func _shake_pilot_profile():
	$pilot.get_node("AnimationTree").play("shake")

func _on_update_player_health(health:float) -> void:
	
	if health >= $health_bar.value:
		# generate heal particles
		var heal = heal_effect.instantiate()
		heal.global_position = $pilot.global_position
		get_parent().add_child(heal)

		#play heal animation for pilot profile
		$pilot.get_node("AnimationTree").play("heal")

	$health_bar.value = health