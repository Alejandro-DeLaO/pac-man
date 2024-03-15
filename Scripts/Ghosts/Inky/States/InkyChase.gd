extends State

@export
var scatter_state : State

var blinky_position: Vector2
var navigation_agent: NavigationAgent2D
var chase_time : float
var chase_timer : float
var pacman_position: Vector2
var current_pacman_state : String
var pinky_target : Vector2

func enter() -> void:
	super()
	chase_time = 20
	chase_timer = chase_time
	pacman_position = parent.PACMAN.global_position
	navigation_agent = parent.navigation_agent
	blinky_position = parent.blinky_instance.global_position
	current_pacman_state = parent.PACMAN.state_machine.current_state.name
	pinky_target = Vector2.ZERO

func process_frame(delta: float) -> State:
	chase_timer -= delta
	return null

func process_physics(_delta: float) -> State:
	var direction = Vector2.ZERO
	current_pacman_state = parent.PACMAN.state_machine.current_state.name
	pacman_position = parent.PACMAN.global_position
	blinky_position = parent.blinky_instance.global_position
	pinky_target = pacman_position
	
	if current_pacman_state == "LeftState":
		pinky_target.x = pacman_position.x - 13
	elif current_pacman_state == "RightState":
		pinky_target.x = pacman_position.x + 13
	elif current_pacman_state == "UpState":
		pinky_target.y = pacman_position.y - 13
	elif current_pacman_state == "DownState":
		pinky_target.y = pacman_position.y + 13
	
	navigation_agent.target_position = 2*(pinky_target) - blinky_position
	
	if chase_timer < 0:
		return scatter_state

	
	direction = navigation_agent.get_next_path_position() - parent.global_position
	direction = direction.normalized()
	
	parent.velocity = direction * parent.SPEED
	
	parent.move_and_slide()
	return null
