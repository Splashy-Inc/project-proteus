extends CanvasLayer

signal start_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_level(level_type: Globals.LevelType) -> void:
	start_level.emit(level_type)
