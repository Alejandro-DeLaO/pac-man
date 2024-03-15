extends State

@export
var left_state: State
@export
var right_state: State
@export
var wait_time: float

var wait_timer: float
var next_state: State 

func enter() -> void:
	super()
	next_state = left_state
	wait_timer = wait_time

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("Right"):
		next_state = right_state
	return null

func process_frame(delta: float) -> State:
	wait_timer -= delta
	return null

func process_physics(_delta: float) -> State:
	if wait_timer < 0:
		return next_state
	return null

