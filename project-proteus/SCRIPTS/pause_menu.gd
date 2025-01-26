extends PanelContainer

signal start_level
signal resume_play
signal main_menu_selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_resume_pressed() -> void:
	resume_play.emit()

func _on_restart_pressed() -> void:
	start_level.emit(Globals.cur_level_type)

func _on_main_menu_pressed() -> void:
	main_menu_selected.emit()
