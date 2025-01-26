extends PanelContainer

signal start_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	start_level.emit(Globals.LevelType.FINITE)

func _on_practice_pressed() -> void:
	start_level.emit(Globals.LevelType.PRACTICE)

func _on_infinite_pressed() -> void:
	start_level.emit(Globals.LevelType.INFINITE)
