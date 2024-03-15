extends State

@export
var left_state: State
@export
var right_state: State
@export
var up_state: State

var next_move: Vector2

func enter() -> void:
	super()
	parent.back_ray_cast.position = Vector2(0, -6)
	parent.front_ray_cast.position = Vector2(0, 6)
	next_move = Vector2.DOWN

func exit() -> void:
	super()
	parent.velocity = Vector2.ZERO

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("Up"):
		next_move = Vector2.UP
	elif Input.is_action_just_pressed("Down"):
		next_move = Vector2.DOWN
	elif Input.is_action_just_pressed("Left"):
		next_move = Vector2.LEFT
	elif Input.is_action_just_pressed("Right"):
		next_move = Vector2.RIGHT
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.can_move_in_direction(next_move):
		if next_move == Vector2.UP:
			return up_state
		if next_move == Vector2.RIGHT:
			return right_state
		if next_move == Vector2.LEFT:
			return left_state
	
	parent.velocity.y = parent.SPEED
	
	parent.move_and_slide()
	
	return null
