extends State


@export
var chase_state : State
@export
var wait_time: float

var wait_timer: float
var navigation_agent : NavigationAgent2D
var home_targets : Array
var current_target : int
var tile_map : TileMap

func enter() -> void:
	tile_map = parent.tile_map
	navigation_agent = parent.navigation_agent
	wait_timer = wait_time
	home_targets = parent.home_targets.get_children() as Array[Node]
	current_target = 0 if parent.name != "Pinky" else 1
	navigation_agent.target_position = home_targets[current_target].global_position
	navigation_agent.target_desired_distance = 5
	navigation_agent.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_CORRIDORFUNNEL
	NavigationServer2D.map_force_update(NavigationServer2D.get_maps()[0])

func exit() -> void:
	navigation_agent.target_desired_distance = 1
	navigation_agent.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_EDGECENTERED

func process_frame(delta: float) -> State:
	wait_timer -= delta
	return null

func process_physics(_delta: float) -> State:
	var direction = Vector2.ZERO
	
	if wait_timer < 0:
		return chase_state
	if navigation_agent.is_target_reached():
		current_target = (current_target + 1) % 2
		navigation_agent.target_position = home_targets[current_target].global_position
	
	direction = navigation_agent.get_next_path_position() - parent.global_position
	direction = direction.normalized()
	
	parent.velocity = direction * parent.SPEED/2
	
	parent.move_and_slide()
	
	return null
