extends TileMapLayer

@export var length_tiles := -1
@export var seed_string: String
@export var camera: Camera2D
var start_point: Vector2
var player_jump_tiles
var next_top_left = Vector2i.ZERO
var window_size: Vector2i
var base_tile_size := Vector2i(Globals.TILE_SIZE)
var tiles_per_window: Vector2i
@export var tiles_per_obstacle = 5
var latest_path_cell: Vector2i
var sections := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_size = Vector2i(get_viewport().get_visible_rect().size)
	tiles_per_window = Vector2i(window_size/base_tile_size)
	player_jump_tiles = floor(Globals.PLAYER_JUMP_HEIGHT/tile_set.tile_size.y)
	
	seed(seed_string.hash())
	
	clear()
	var base_tile_set = tile_set.get_source(1)
	if base_tile_set is TileSetAtlasSource:
		base_tile_size = base_tile_set.get_tile_texture_region(Vector2i.ZERO).size
	if length_tiles <= 0:
		start_point = generate_section(next_top_left, tiles_per_window, tiles_per_obstacle, latest_path_cell)
	elif length_tiles > 0:
		start_point = generate_section(next_top_left, Vector2i(length_tiles, tiles_per_window.y), tiles_per_obstacle, latest_path_cell)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if camera and length_tiles <= 0:
		var camera_tile = local_to_map(to_local(camera.global_position))
		if camera_tile.x > next_top_left.x - tiles_per_window.x * 2:
			generate_section(next_top_left, next_top_left + tiles_per_window, tiles_per_obstacle, latest_path_cell)

func initialize(new_length: int, new_seed: String):
	length_tiles = new_length
	seed_string = new_seed

func generate_section(top_left: Vector2i, bottom_right: Vector2i, avg_tiles_per_obstacle: int, prev_path_cell: Vector2i):
	var origin = top_left
	var size = bottom_right - origin
	var start_position
	
	for x in size.x:
		var column_data = Globals.level_column_data_struct.duplicate(true)
		column_data["height"] = size.y
		column_data["bottom_cell"] = Vector2i(x+origin.x,bottom_right.y)
		if x > 0 and x % avg_tiles_per_obstacle == 0:
			column_data["num_obstacles"] += 1
		prev_path_cell = generate_column(column_data, prev_path_cell)
		if x == 0:
			column_data["is_start_column"] = true
			start_position = to_global(map_to_local(prev_path_cell))
	
	# TODO: Figure out how to avoid process spike when updating autotiler
	var section_rect = Rect2i(origin, size)
	var section_cells = []
	for x in section_rect.size.x:
		for y in section_rect.size.y:
			var new_cell = Vector2i(section_rect.position) + Vector2i(x,y)
			if get_cell_source_id(new_cell) == 1:
				section_cells.append(new_cell)
	set_cells_terrain_connect(section_cells,0,0,false)
	next_top_left = Vector2i(bottom_right.x, next_top_left.y)
	latest_path_cell = prev_path_cell
	sections.append([top_left,bottom_right])
	return start_position

func generate_column(column_data: Dictionary, prev_path_cell) -> Vector2i:
	var bottom_cell = column_data["bottom_cell"]
	var height = column_data["height"]
	
	var path_cell = bottom_cell - Vector2i(0, randi_range(1,height))
	if prev_path_cell:
		path_cell = prev_path_cell + Vector2i(1, randi_range(-player_jump_tiles,player_jump_tiles))
		if path_cell.y >= bottom_cell.y:
			path_cell.y = bottom_cell.y - 1
		elif path_cell.y <= bottom_cell.y - height:
			path_cell.y = bottom_cell.y - height + 1
	
	var x = bottom_cell.x
	for y in height:
		# Start at bottom cell and build up from there
		var cur_cell = Vector2i(x,bottom_cell.y-y)
		
		# Fill terrain tiles under path cell
		if cur_cell.y > path_cell.y:
			set_cell(cur_cell,1,Vector2i(0,11))
			
		# Place an obstacle in the path cell if terrain height between path cells increased by max jump height
		#   Only place if we have obstacles we can place
		elif prev_path_cell and cur_cell == path_cell and column_data["num_obstacles"] > 0:
			if prev_path_cell.y == cur_cell.y + player_jump_tiles:
				set_cell(cur_cell,2,Vector2i(0,0),randi_range(1,2))
			
	return path_cell
	
func delete_section(top_left: Vector2i, bottom_right: Vector2i):
	for x in range(top_left.x, bottom_right.x+1):
		for y in range(top_left.y, bottom_right.y+1):
			erase_cell(Vector2i(x, y))

func _on_section_delete_timer_timeout() -> void:
	if not sections.is_empty():
		var section_to_delete = sections.pop_front()
		delete_section(section_to_delete[0], section_to_delete[1])	
