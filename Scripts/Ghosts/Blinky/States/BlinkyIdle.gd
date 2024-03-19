extends State

@export
var chase_state : State
@export
var wait_time: float

var wait_timer: float

func enter() -> void:
	super()
	wait_timer = wait_time


func process_frame(delta: float) -> State:
	wait_timer -= delta
	return null

func process_physics(_delta: float) -> State:
	if wait_timer < 0:
		return chase_state
	return null

