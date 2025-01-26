extends Node

enum Type {
	NONE,
	SLASHING,
	BLUDGEONING,
}

enum CollisionLayer {
	PLAYER,
	PLAYER_ATTACK,
	TARGET,
	OBSTACLE,
}

enum LevelType {
	PRACTICE,
	FINITE,
	INFINITE,
}

var level_column_data_struct = {
	"is_start_column": false,
	"bottom_tile": Vector2i.ZERO,
	"height": 0,
	"num_obstacles": 2,
}

const TILE_SIZE = Vector2(64,64)
const PLAYER_JUMP_HEIGHT = TILE_SIZE.y * 2
const PLAYER_SPEED_TILES = 4
const PLAYER_SPEED = TILE_SIZE.x * PLAYER_SPEED_TILES
const CAMERA_MIN_X_DEFAULT = -10.0 * TILE_SIZE.x

var camera_min_x := CAMERA_MIN_X_DEFAULT

var cur_level_type: LevelType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset():
	camera_min_x = CAMERA_MIN_X_DEFAULT
