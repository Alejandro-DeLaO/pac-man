extends CharacterBody2D

class_name Ghost

const SPEED = 65

@export 
var scatter_targets: Node
@export 
var home_targets: Node
@export
var PACMAN: CharacterBody2D
@export
var tile_map : TileMap

@onready var state_machine : StateMachine = $StateMachine
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@onready var eye_sprite : Sprite2D = $EyeSprite
@onready var body_sprite : Sprite2D = $BodySprite

@onready var frightened_state : State = $StateMachine/Frightened
@onready var back_home_state : State = $StateMachine/BackHome
@onready var idle_state : State = $StateMachine/Idle

func _ready():
	state_machine.init(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	state_machine.process_frame(delta)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
