extends Node
class_name State

@export
var animation_name: String
var parent: CharacterBody2D

func enter() -> void:
	if animation_name:
		parent.animation_player.play(animation_name)
		

func exit() -> void:
	parent.animation_player.pause()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null


