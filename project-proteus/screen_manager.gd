extends Node

@export var level_scene: PackedScene

var cur_level
var level_length := -1
var level_minutes = 1

func _ready():
	cur_level = $Levels.find_child("Level")
	get_tree().paused = true

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

func _on_game_loss():
	cur_level.queue_free()
	cur_level = null
	$HUD.show()

func _on_start_level(level_type: Globals.LevelType) -> void:
	match level_type:
		Globals.LevelType.FINITE:
			level_length = level_minutes * 60 * Globals.PLAYER_SPEED_TILES
		Globals.LevelType.INFINITE:
			level_length = -1
		Globals.LevelType.PRACTICE:
			level_length = 0
	
	_reset_game_board(level_type)
	
	if cur_level:
		$HUD.hide()
	
	get_tree().paused = false
