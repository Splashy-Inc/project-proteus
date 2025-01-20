extends TileMapLayer

signal scenes_ready

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("_scenes_ready")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _scenes_ready():
	scenes_ready.emit()
	for target in get_tree().get_nodes_in_group("targets"):
		if target is Target:
			var rand_type = randi_range(Globals.Type.NONE, Globals.Type.BLUDGEONING)
			var rand_obstacle = bool(randi_range(0,1))
			target.initialize(rand_type, true, rand_obstacle) # Always destructible for now
