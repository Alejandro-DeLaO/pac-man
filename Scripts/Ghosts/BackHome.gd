extends State

@export
var chase_state : State

var home_target : Marker2D
var target_array : Array[Node]
var navigation_agent : NavigationAgent2D

func enter() -> void:
	super()
	parent.body_sprite.visible = false
	parent.eye_sprite.visible = true
	navigation_agent = parent.navigation_agent
	target_array = parent.home_targets.get_children() as Array[Node]
	home_target = target_array[1]
	navigation_agent.target_desired_distance = 5

func exit() -> void:
	parent.body_sprite.visible = true
	parent.eye_sprite.visible = false
	navigation_agent.target_desired_distance = 1
	
func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	var direction = Vector2.ZERO
	
	if navigation_agent.is_target_reached(): 
		return chase_state
	
	navigation_agent.target_position = home_target.global_position
	direction = navigation_agent.get_next_path_position() - parent.global_position
	direction = direction.normalized()
	
	parent.velocity = direction * parent.SPEED * 3

	parent.move_and_slide()
	return null
