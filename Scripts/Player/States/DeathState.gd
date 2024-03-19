extends State
signal player_death


func process_physics(_delta: float) -> State:
	if !parent.animation_player.is_playing():
		emit_signal("player_death")
	return null

