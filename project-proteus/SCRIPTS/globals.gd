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

var level_column_data_struct = {
	"is_start_column": false,
	"bottom_tile": Vector2i.ZERO,
	"height": 0,
	"num_obstacles": 2,
}

const TILE_SIZE = Vector2(64,64)
const PLAYER_JUMP_HEIGHT = TILE_SIZE.y * 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
