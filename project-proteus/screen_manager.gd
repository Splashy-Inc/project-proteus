extends Node

@export var level_scene: PackedScene

var cur_level
var level_length := -1
var level_minutes = 1

func _ready():
	cur_level = $Levels.find_child("Level")
	$HUD.hide()
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused == false:
			_pause_play()
		else:
			_on_resume_play()

func _reset_game_board(level_type: Globals.LevelType):
	Globals.reset()
	if cur_level:
		cur_level.queue_free()
		cur_level = null
	var new_level = level_scene.instantiate()
	if new_level is Level:
		new_level.initialize(level_length, level_type, 'res://ASSETS/level_sample.json')
	$Levels.add_child(new_level)
	new_level.level_loss.connect(_on_game_loss)
	new_level.level_win.connect(_on_game_win)
	cur_level = new_level
	_on_resume_play()

func _on_game_loss():
	cur_level.queue_free()
	cur_level = null
	$HUD.show_loss_screen()

func _on_game_win():
	cur_level.queue_free()
	cur_level = null
	$HUD.show_win_screen()

func _on_start_level(level_type: Globals.LevelType) -> void:
	Globals.cur_level_type = level_type
	
	match level_type:
		Globals.LevelType.FINITE:
			level_length = level_minutes * 60 * Globals.PLAYER_SPEED_TILES
		Globals.LevelType.INFINITE:
			level_length = -1
		Globals.LevelType.PRACTICE:
			level_length = 0
	
	_reset_game_board(level_type)
	
	if cur_level:
		$HUD.hide_menus()
	
	get_tree().paused = false

func _on_resume_play() -> void:
	if not $IntroCutscene:
		$HUD.hide_menus()
		get_tree().paused = false

func _pause_play():
	$HUD.show_pause_menu()
	get_tree().paused = true

func _on_intro_cutscene_ended() -> void:
	$HUD.show()
