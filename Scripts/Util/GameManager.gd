extends Node


@onready var ui = $UI as UI
@onready var pellets = $Pellets
@onready var player = $Player
@onready var ghosts = $Ghosts
@onready var waka_waka = $AudioPlayers/WakaWaka
@onready var begining_music = $AudioPlayers/Begining
@onready var death = $AudioPlayers/Death
@onready var ghost_eaten = $AudioPlayers/GhostEaten
@onready var power_pellet = $AudioPlayers/PowerPellet


var total_pellets_count
var pellets_eaten = 0
var score = 0
var lives = 1
var ghosts_array 
# Called when the node enters the scene tree for the first time.
func _ready():
	var pellets_array = pellets.get_children() as Array[Pellet]
	ghosts_array = ghosts.get_children()
	total_pellets_count = pellets_array.size()
	for pellet in pellets_array:
		pellet.pellet_eaten.connect(on_pellet_eaten)
		pellet.power_pellet_eaten.connect(on_power_pellet_eaten)
	begining_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _unhandled_input(_event):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()

func _on_left_tp_body_entered(body):
	print(body)
	body.position.x = 232


func _on_right_tp_body_entered(body):
	print(body)
	body.position.x = -8

func on_pellet_eaten():
	if !waka_waka.playing:
		waka_waka.play(.16)
	pellets_eaten += 1
	score += 10
	ui.update_score(score)
	if pellets_eaten == total_pellets_count: 
		game_won()
		
func game_won():
	ui.game_won()
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()

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
		get_tree().reload_current_scene()

func on_power_pellet_effect_finished():
	power_pellet.stop()

func _on_p_area_body_entered(body):
	if body is Player and ghosts_array[1].state_machine.current_state.name == "Frightened":
		ghosts_array[1].state_machine.change_state(ghosts_array[1].back_home_state)
		get_tree().paused = true
		await get_tree().create_timer(1.0).timeout
		get_tree().paused = false
		ghost_eaten.play()
	elif ghosts_array[1].state_machine.current_state.name != "BackHome":
		if !death.playing:
			death.play()
		body.state_machine.change_state(body.DeathState)


func _on_c_area_body_entered(body):
	if body is Player and ghosts_array[3].state_machine.current_state.name == "Frightened":
		ghosts_array[3].state_machine.change_state(ghosts_array[3].back_home_state)
		get_tree().paused = true
		await get_tree().create_timer(1.0).timeout
		get_tree().paused = false
		ghost_eaten.play()
	elif ghosts_array[3].state_machine.current_state.name != "BackHome":
		if !death.playing:
			death.play()
		body.state_machine.change_state(body.DeathState)


func _on_i_area_body_entered(body):
	if body is Player and ghosts_array[2].state_machine.current_state.name == "Frightened":
		ghosts_array[2].state_machine.change_state(ghosts_array[2].back_home_state)
		get_tree().paused = true
		await get_tree().create_timer(1.0).timeout
		get_tree().paused = false
		ghost_eaten.play()
	elif ghosts_array[2].state_machine.current_state.name != "BackHome":
		if !death.playing:
			death.play()
		body.state_machine.change_state(body.DeathState)


func _on_b_area_body_entered(body):
	if body is Player and ghosts_array[0].state_machine.current_state.name == "Frightened":
		ghosts_array[0].state_machine.change_state(ghosts_array[0].back_home_state)
		get_tree().paused = true
		await get_tree().create_timer(1.0).timeout
		get_tree().paused = false
		ghost_eaten.play()
	elif ghosts_array[0].state_machine.current_state.name != "BackHome":
		if !death.playing:
			death.play()
		body.state_machine.change_state(body.DeathState)
