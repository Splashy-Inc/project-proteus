extends Node

@export var level_scene: PackedScene

var cur_level
var level_length := -1
var level_minutes = 1

func _ready():
	cur_level = $Levels.find_child("Level")
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
		var lose_speed = (Globals.PLAYER_SPEED / 4) / 60
		new_level.initialize(level_length, level_type, lose_speed)
	$Levels.add_child(new_level)
	new_level.level_loss.connect(_on_game_loss)
	cur_level = new_level
	_on_resume_play()

func _on_game_loss():
	cur_level.queue_free()
	cur_level = null
	$HUD.show_main_menu()

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
	$HUD.hide_menus()
	get_tree().paused = false

func _pause_play():
	$HUD.show_pause_menu()
	get_tree().paused = true
