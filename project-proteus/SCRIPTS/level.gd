extends Node

class_name Level

signal level_loss

@export var player_scene: PackedScene
@export var camera: Camera2D
@export var can_lose = false
@export var lose_point_speed_tiles_per_second := 1.0
@export var type: Globals.LevelType
@export var level_data_path: String

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if type != Globals.LevelType.PRACTICE:
		Globals.camera_min_x += lose_point_speed_tiles_per_second * Globals.TILE_SIZE.x * delta

func initialize(new_type: Globals.LevelType, new_lose_speed: float, json_path: String):
	type = new_type
	lose_point_speed_tiles_per_second = new_lose_speed
	level_data_path = json_path
	
	$LevelTileLayer.initialize(json_path)

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

func _on_level_tile_layer_ready() -> void:
	call_deferred("_spawn_player", $LevelTileLayer.start_point)
	
func _on_player_died():
	level_loss.emit()
