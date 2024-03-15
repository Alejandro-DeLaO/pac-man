extends State

func exit() -> void:
	parent.animation_player.pause()

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if !parent.animation_player.is_playing():
		get_tree().reload_current_scene()
	return null

