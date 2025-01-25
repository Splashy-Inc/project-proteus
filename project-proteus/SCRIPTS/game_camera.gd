extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	limit_bottom = Globals.TILE_SIZE.y * 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	limit_left = Globals.camera_min_x
