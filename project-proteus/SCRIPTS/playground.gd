extends Node

@export var max_height_tiles = 10
@export var player_scene: PackedScene
@export var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LevelTileLayer.clear()
	var spawn_point = $LevelTileLayer.generate_section(Vector2i.ZERO, Vector2i(1000,max_height_tiles), 5)
	_spawn_player(spawn_point)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _spawn_player(spawn_point: Vector2):
	var new_player = player_scene.instantiate()
	add_child(new_player)
	new_player.global_position = spawn_point
	camera.reparent(new_player,false)
	camera.position = Vector2.ZERO
	if $Proteus:
		$Proteus.queue_free()

func _on_level_tile_layer_ready() -> void:
	if $LevelTileLayer.generate_random:
		call_deferred("_spawn_player", $LevelTileLayer.start_point)
