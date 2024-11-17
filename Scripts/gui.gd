extends Control

var score = 0
var new_score = 0
signal update_score(s)
@onready var scoreLabel = $score

func _process(delta: float) -> void:
	if score < new_score:
		score += 5
		scoreLabel.set_text("Score: %d" % score)

func _on_update_score(s:int) -> void:
	new_score = s
