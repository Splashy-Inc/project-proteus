extends TileMapLayer

@export var level_data_path: String
@export var camera: Camera2D

var level_data: Dictionary
var start_point: Vector2
var next_top_left = Vector2i.ZERO
var full_height = 15

func _ready() -> void:
	var file = FileAccess.open(level_data_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			level_data = json.get_data()
		else:
			print("JSON Parse Error: ", json.get_error_message())
		file.close()
	
	clear()
	
	if level_data and "data" in level_data:
		generate_full_level()

func generate_full_level() -> void:
	var size = level_data.get("size", [10, 10])
	var width = size[0]
	var height = size[1]
	var terrain_cells = []
	
	for chunk in level_data["data"]:
		terrain_cells += generate_chunk(chunk, next_top_left.x, height)
		next_top_left.x += width
	
	# Connect terrain after full generation
	set_cells_terrain_connect(terrain_cells, 0, 0, false)

func generate_chunk(chunk: Dictionary, start_x: int, height: int) -> Array:
	var size = level_data.get("size", [10, 10])
	var width = size[0]
	var grid = chunk["grid"]
	var terrain_cells = []
	
	for y in full_height:
		for x in width:
			var cell_value = 1 # default to terrain to pad below the chunk
			if y < height:
				var index = x + y * width
				cell_value = int(grid[index])
			var cur_cell = Vector2i(start_x + x, y)
			
			# Find start point (first terrain tile)
			if start_point == Vector2() and x == 0 and cell_value == 1:
				start_point = to_global(map_to_local(cur_cell + Vector2i(0,-1)))

			match cell_value:
				0:  # Empty
					continue
				1:  # Terrain
					set_cell(cur_cell, 1, Vector2i(0, 11))
					terrain_cells.append(cur_cell)
				2:  # Obstacle
					set_cell(cur_cell, 2, Vector2i(0, 0), randi_range(1, 2))
	
	return terrain_cells
func initialize(json_path: String):
	level_data_path = json_path
	_ready()
