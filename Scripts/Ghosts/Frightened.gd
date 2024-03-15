extends State

@export
var chase_state : State

var pacman_position: Vector2
var navigation_agent: NavigationAgent2D
var frightened_time : float
var frightened_timer : float
var next_direction : Vector2

func enter() -> void:
	super()
	next_direction = parent.global_position - Vector2(RandomNumberGenerator.new().randi_range(-1,1), RandomNumberGenerator.new().randi_range(-1,1))*10
	frightened_time = 10
	frightened_timer = frightened_time
	navigation_agent = parent.navigation_agent
	pacman_position = parent.PACMAN.global_position
	


func process_frame(delta: float) -> State:
	frightened_timer -= delta
	return null

func process_physics(_delta: float) -> State:
	var direction = Vector2.ZERO
	if frightened_timer < 3:
		parent.animation_player.play("ending_fright")
	if frightened_timer < 0:
		return chase_state
	if navigation_agent.is_target_reached() or !navigation_agent.is_target_reachable():
		next_direction = parent.global_position - Vector2(RandomNumberGenerator.new().randi_range(-1,1), RandomNumberGenerator.new().randi_range(-1,1))*120
	
	pacman_position = parent.PACMAN.global_position
	navigation_agent.target_position = next_direction
	direction = navigation_agent.get_next_path_position() - parent.global_position
	direction = direction.normalized()
	
	parent.velocity = direction * parent.SPEED
	
	parent.move_and_slide()
	return null

