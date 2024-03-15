extends State

@export
var scatter_state : State

var pacman_position: Vector2
var navigation_agent: NavigationAgent2D
var chase_time : float
var chase_timer : float
var current_pacman_state : String

func enter() -> void:
	super()
	chase_time = 20
	chase_timer = chase_time
	navigation_agent = parent.navigation_agent
	pacman_position = parent.PACMAN.global_position
	current_pacman_state = parent.PACMAN.state_machine.current_state.name


func process_frame(delta: float) -> State:
	chase_timer -= delta
	return null

func process_physics(_delta: float) -> State:
	var direction = Vector2.ZERO
	current_pacman_state = parent.PACMAN.state_machine.current_state.name
	pacman_position = parent.PACMAN.global_position
	navigation_agent.target_position = pacman_position
	
	if chase_timer < 0:
		return scatter_state
	
	if current_pacman_state == "LeftState":
		navigation_agent.target_position.x = pacman_position.x - 13
	elif current_pacman_state == "RightState":
		navigation_agent.target_position.x = pacman_position.x + 13
	elif current_pacman_state == "UpState":
		navigation_agent.target_position.y = pacman_position.y - 13
	elif current_pacman_state == "DownState":
		navigation_agent.target_position.y = pacman_position.y + 13
	
	direction = navigation_agent.get_next_path_position() - parent.global_position
	direction = direction.normalized()
	
	parent.velocity = direction * parent.SPEED
	
	parent.move_and_slide()
	return null
