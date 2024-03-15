extends Area2D

class_name Pellet

signal pellet_eaten()
signal power_pellet_eaten()

@export 
var can_eat_ghosts: bool


func _on_body_entered(body):
	if body is Player:
		if can_eat_ghosts:
			power_pellet_eaten.emit()
		else:
			pellet_eaten.emit()
		queue_free()
