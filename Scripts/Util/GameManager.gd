extends Node


@onready var ui = $UI as UI
@onready var pellets_scene = preload("res://Scenes/pellets_position.tscn")
@onready var player : Player = $Player
@onready var ghosts = $Ghosts
@onready var waka_waka = $AudioPlayers/WakaWaka
@onready var begining_music = $AudioPlayers/Begining
@onready var death = $AudioPlayers/Death
@onready var ghost_eaten = $AudioPlayers/GhostEaten
@onready var power_pellet = $AudioPlayers/PowerPellet

var pellets_instance
var pellets_node_in_tree
var total_pellets_count
var pellets_eaten = 0
var score = 0
var lives = 1
var ghosts_array
# Called when the node enters the scene tree for the first time.
func _ready():
	pellets_instanciation_process()
	ghosts_array = ghosts.get_children()
	player.death_state.player_death.connect(game_reset)
	begining_music.play()

func pellets_instanciation_process():
	pellets_instance = pellets_scene.instantiate()
	add_child(pellets_instance)
	pellets_node_in_tree = $Pellets
	var pellets_array = pellets_node_in_tree.get_children() as Array[Pellet]
	total_pellets_count = pellets_array.size()
	for pellet in pellets_array:
		pellet.pellet_eaten.connect(on_pellet_eaten)
		pellet.power_pellet_eaten.connect(on_power_pellet_eaten)


func _unhandled_input(_event):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()


func game_reset():
	#hiding game won panel
	ui.game_reset()
	
	#reseting states
	player.state_machine.change_state(player.idle_state)
	for ghost in ghosts_array:
		ghost.state_machine.change_state(ghost.idle_state)
	
	#reseting position
	player.position = Constants.PACMAN_INIT_POSITION
	ghosts_array[0].position = Constants.BLINKY_INIT_POSITION
	ghosts_array[1].position = Constants.PINKY_INIT_POSITION
	ghosts_array[2].position = Constants.INKY_INIT_POSITION
	ghosts_array[3].position = Constants.CLYDE_INIT_POSITION
	
	#waiting for all signals to be freed
	await get_tree().create_timer(0.1).timeout
	
	#pellet instanciation
	pellets_node_in_tree.free()
	pellets_instanciation_process()
	
	#restarting score values
	pellets_eaten = 0
	score = 0
	ui.update_score(score)
	begining_music.play()


func game_won():
	ui.game_won()
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = false
	game_reset()

#pellet functionality
func on_pellet_eaten():
	if !waka_waka.playing:
		waka_waka.play(.16)
	pellets_eaten += 1
	score += 10
	ui.update_score(score)
	if pellets_eaten == total_pellets_count: 
		game_won()
		

#power pellet functionaliy
func on_power_pellet_eaten():
	power_pellet.play()
	get_tree().create_timer(10).timeout.connect(on_power_pellet_effect_finished)
	
	pellets_eaten += 1
	score += 50
	ui.update_score(score)
	for ghost in ghosts_array:
		if ghost.state_machine.current_state.name != "Idle" and ghost.state_machine.current_state.name != "BackHome": 
			ghost.state_machine.change_state(ghost.frightened_state)
	if pellets_eaten == total_pellets_count: 
		game_won()

func on_power_pellet_effect_finished():
	power_pellet.stop()






#ghots collision with player
func _on_b_area_body_entered(body):
	on_ghost_collision(body, ghosts_array[0])

func _on_p_area_body_entered(body):
	on_ghost_collision(body, ghosts_array[1])
	
func _on_i_area_body_entered(body):
	on_ghost_collision(body, ghosts_array[2])

func _on_c_area_body_entered(body):
	on_ghost_collision(body, ghosts_array[3])

func on_ghost_collision(body, ghost):
	if body is Player and ghost.state_machine.current_state.name == "Frightened":
		ghost.state_machine.change_state(ghost.back_home_state)
		get_tree().paused = true
		await get_tree().create_timer(1.0).timeout
		get_tree().paused = false
		ghost_eaten.play()
	elif ghost.state_machine.current_state.name != "BackHome":
		if !death.playing:
			death.play()
		body.state_machine.change_state(body.death_state)


#teleportation

func _on_left_tp_body_entered(body):
	print(body)
	body.position.x = 232


func _on_right_tp_body_entered(body):
	print(body)
	body.position.x = -8
