extends CanvasLayer

class_name UI

@onready var center_container = $MarginContainer/CenterContainer
@onready var scoreLabel = $TopPanel/Score
@onready var label = $TopPanel/Label


func game_won():
	center_container.show()

func update_score(score : int):
	scoreLabel.text = "1 up \n" + str(score)
	label.text = "1 up \n" + str(score)
