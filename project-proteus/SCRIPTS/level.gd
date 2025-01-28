extends Node

class_name Level

signal level_loss
signal level_win

@export var player_scene: PackedScene
@export var camera: Camera2D
@export var can_lose = false
@export var type: Globals.LevelType
@export var level_data_path: String
@export var length_tiles := 0
@export var cur_player: Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if type != Globals.LevelType.PRACTICE and cur_player:
		Globals.camera_min_x += Globals.LOSE_POINT_SPEED * delta
		if Globals.camera_min_x < cur_player.global_position.x - Globals.MAX_LOSE_DISTANCE_TO_PLAYER:
			Globals.camera_min_x = cur_player.global_position.x - Globals.MAX_LOSE_DISTANCE_TO_PLAYER
		if $FishMob.visible:
			$FishMob.global_position.x = Globals.camera_min_x + 50

func initialize(new_length: int, new_type: Globals.LevelType, json_path: String):
	length_tiles = new_length
	type = new_type
	level_data_path = json_path
	if type == Globals.LevelType.FINITE:
		camera.limit_right = length_tiles * Globals.TILE_SIZE.x
	
	$LevelTileLayer.initialize(length_tiles, json_path)
	
	if type == Globals.LevelType.PRACTICE:
		$FishMob.hide()

func _spawn_player(spawn_point: Vector2):
	var new_player = player_scene.instantiate()
	add_child(new_player)
	camera.reparent(new_player,false)
	camera.position = Vector2.ZERO
	for player in get_tree().get_nodes_in_group("player"):
		if player != new_player:
			player.queue_free()
	new_player.died.connect(_on_player_died)
	new_player.initialize(spawn_point)
	cur_player = new_player

func _on_level_tile_layer_ready() -> void:
	call_deferred("_spawn_player", $LevelTileLayer.start_point)
	
func _on_player_died():
	if cur_player.global_position.x < $FishMob.global_position.x:
		level_loss.emit()
	else:
		level_win.emit()
