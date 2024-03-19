extends CharacterBody2D

class_name Player

const SPEED = 70

@onready
var state_machine : StateMachine = $StateMachine
@onready
var sprite : Sprite2D = $Sprite2D
@onready
var animation_player : AnimationPlayer = $AnimationPlayer
@onready
var back_ray_cast : RayCast2D = $BackRayCast2D
@onready
var middle_ray_cast : RayCast2D = $MiddleRayCast2D
@onready
var front_ray_cast : RayCast2D = $FrontRayCast2D

@onready
var death_state : State = $StateMachine/DeathState

@onready
var idle_state : State = $StateMachine/IdleState

#Called when the player has entered the scene tree
func _ready() -> void:
	state_machine.init(self)

#Called when an input is provided
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

#Called each frame
func _process(delta: float) -> void:
	state_machine.process_frame(delta)

#Called each physics frame (every 1/60 seconds)
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func can_move_in_direction(next_move : Vector2) -> bool:
	back_ray_cast.target_position = next_move * 10
	middle_ray_cast.target_position = next_move * 10
	front_ray_cast.target_position = next_move * 10
	back_ray_cast.force_raycast_update()
	middle_ray_cast.force_raycast_update()
	front_ray_cast.force_raycast_update()
	return not back_ray_cast.is_colliding() && not middle_ray_cast.is_colliding() && not front_ray_cast.is_colliding()




