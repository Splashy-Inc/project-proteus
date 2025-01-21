extends TileMapLayer

@export var generate_random := false
@export var seed: String
@export var camera: Camera2D
var start_point: Vector2
var player_jump_tiles
var next_top_left = Vector2i.ZERO
var window_size: Vector2i
var tiles_per_window: Vector2i
var tiles_per_obstacle = 5
var latest_path_cell: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var base_tile_size = Vector2i(Globals.PLAYER_JUMP_HEIGHT/2,Globals.PLAYER_JUMP_HEIGHT/2)
	window_size = Vector2i(get_viewport().get_visible_rect().size)
	tiles_per_window = Vector2i(window_size/base_tile_size)
	player_jump_tiles = floor(Globals.PLAYER_JUMP_HEIGHT/tile_set.tile_size.y)
	
	if seed:
		seed(seed.hash())
		
	if generate_random:
		clear()
		var base_tile_set = tile_set.get_source(1)
		if base_tile_set is TileSetAtlasSource:
			base_tile_size = base_tile_set.get_tile_texture_region(Vector2i.ZERO).size
		start_point = generate_section(next_top_left, tiles_per_window, tiles_per_obstacle, latest_path_cell)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if camera and generate_random:
		var camera_tile = local_to_map(to_local(camera.global_position))
		if camera_tile.x  > next_top_left.x - tiles_per_window.x * 2:
			generate_section(next_top_left, next_top_left + tiles_per_window, tiles_per_obstacle, latest_path_cell)

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
	#set_cells_terrain_connect(get_used_cells_by_id(1),0,0,false)
	next_top_left = Vector2i(bottom_right.x, next_top_left.y)
	latest_path_cell = prev_path_cell
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
				set_cell(cur_cell,2,Vector2i(0,0),1)
			
	return path_cell
