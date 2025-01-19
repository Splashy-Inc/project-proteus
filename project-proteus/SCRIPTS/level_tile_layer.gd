extends TileMapLayer

@export var generate_random := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if generate_random:
		clear()
		var window_size = Vector2i(get_viewport().get_visible_rect().size)
		var base_tile_set = tile_set.get_source(3)
		var base_tile_size = Vector2i(128,128)
		if base_tile_set is TileSetAtlasSource:
			base_tile_size = base_tile_set.get_tile_texture_region(Vector2i.ZERO).size
			print(base_tile_size)
			print(Vector2i(window_size/base_tile_size))
		generate_section(Vector2i(0,0), Vector2i(window_size/base_tile_size))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate_section(top_left: Vector2i, bottom_right: Vector2i):
	var origin = top_left
	var size = bottom_right - top_left + Vector2i(1,1)
	
	for x in size.x:
		generate_column(size.y, Vector2(x,bottom_right.y))

func generate_column(height: int, bottom_cell: Vector2i):
	var x = bottom_cell.x
	for y in height:
		var cur_cell = Vector2i(x,bottom_cell.y-y)
		if cur_cell == bottom_cell:
			set_cell(cur_cell,3,Vector2i(0,0))
		else:
			pass
