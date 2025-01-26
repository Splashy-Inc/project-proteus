extends CanvasLayer

signal start_level
signal resume_play

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_main_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_level(level_type: Globals.LevelType) -> void:
	start_level.emit(level_type)

func show_main_menu():
	hide_menu_buttons()
	$MenuPanel.show()
	$MenuPanel/HBoxContainer/MenuSections/MenuButtons/MainMenu.show()

func show_pause_menu():
	hide_menu_buttons()
	$MenuPanel.show()
	$MenuPanel/HBoxContainer/MenuSections/MenuButtons/PauseMenu.show()

func hide_menu_buttons():
	for child in $MenuPanel/HBoxContainer/MenuSections/MenuButtons.get_children():
		child.hide()

func hide_menus():
	$MenuPanel.hide()

func _on_pause_menu_main_menu_selected() -> void:
	show_main_menu()

func _on_pause_menu_resume_play() -> void:
	resume_play.emit()
