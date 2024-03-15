extends State

@export
var scatter_state : State

var pacman_position: Vector2
var navigation_agent: NavigationAgent2D
var chase_time : float
var chase_timer : float

func enter() -> void:
	super()
	chase_time = 20
	chase_timer = chase_time
	navigation_agent = parent.navigation_agent
	pacman_position = parent.PACMAN.global_position


func process_frame(delta: float) -> State:
	chase_timer -= delta
	return null

func process_physics(_delta: float) -> State:
	var direction = Vector2.ZERO
	if chase_timer < 0:
		return scatter_state
	
	pacman_position = parent.PACMAN.global_position
	if sqrt(pow(parent.global_position.x - pacman_position.x, 2)+pow(parent.global_position.y - pacman_position.y, 2)) <= 64:
		return scatter_state 
	
	
	navigation_agent.target_position = pacman_position
	direction = navigation_agent.get_next_path_position() - parent.global_position
	direction = direction.normalized()
	
	parent.velocity = direction * parent.SPEED
	
	parent.move_and_slide()
	return null
