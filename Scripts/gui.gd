extends Control

var score = 0
var new_score = 0
const SPECIAL_RATE = .2
var special_rate_modifier = 1
var charge_special = true
signal update_score(s)
signal shake_pilot
signal update_player_health(health)
signal reset_special_bar
signal start_charging_special
signal tired_pilot
@onready var scoreLabel = $score
@onready var death_profile = preload("res://Sprites/pilot_dead.png")
@onready var tired_profile = preload("res://Sprites/pilot/pilot_tired.png")
@onready var heal_effect = preload("res://Scenes/effects/heal_effect.tscn")
@onready var player = get_parent().get_parent().get_node_or_null("Player")

func _process(delta: float) -> void:
	if score < new_score:
		score += 5
		scoreLabel.set_text("Score: %d" % score)

	if (get_parent().get_parent().get_node_or_null("Player") == null):
		$pilot.texture = death_profile

	#increases special bar over time
	if charge_special:
		$special.value += SPECIAL_RATE * special_rate_modifier
	
	#when special bar is full send signal to player to turn on special mode
	if ($special.value >= $special.max_value) and (player != null):
		player.emit_signal("special_mode")
		charge_special = false

func _on_tired_pilot():
	$pilot.get_node("AnimationTree").play("tired")

func _on_reset_special_bar():
	$special.value = 0

func _on_start_charging_special():
	charge_special = true

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
