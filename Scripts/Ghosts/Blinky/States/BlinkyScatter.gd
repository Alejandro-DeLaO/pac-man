extends State

@export
var chase_state : State

var scatter_points
var points_array : Array[Marker2D]
var navigation_agent: NavigationAgent2D
var current_target : int
var scatter_time : float
var scatter_timer : float

func enter() -> void:
	super()
	scatter_time = RandomNumberGenerator.new().randf_range(5.0, 7.0)
	scatter_timer = scatter_time
	current_target = 0
	navigation_agent = parent.navigation_agent
	scatter_points = parent.scatter_targets
	for point in scatter_points.get_children():
		points_array.append(point)
# Called when the node enters the scene tree for the first time.

func process_frame(delta: float) -> State:
	scatter_timer -= delta
	return null

func process_physics(_delta: float) -> State:
	if scatter_timer < 0:
		return chase_state
		
	var direction = Vector2.ZERO
	if navigation_agent.is_target_reached(): 
		current_target = (current_target + 1) % 4
	navigation_agent.target_position = points_array[current_target].global_position
	direction = navigation_agent.get_next_path_position() - parent.global_position
	direction = direction.normalized()
	
	parent.velocity = direction * parent.SPEED
	


	parent.move_and_slide()
	return null
