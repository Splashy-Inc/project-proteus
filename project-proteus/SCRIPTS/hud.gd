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

func _on_control_toggle_pressed() -> void:
	_set_control_visibility(not $MenuPanel/HBoxContainer/MenuSections/KeyboardControls.visible)
		
func _set_control_visibility(is_visible: bool):
	$MenuPanel/HBoxContainer/MenuSections/KeyboardControls.visible = is_visible
	$MenuPanel/HBoxContainer/MenuSections/ControllerControls.visible = is_visible
	if $MenuPanel/HBoxContainer/MenuSections/KeyboardControls.visible:
		$MenuPanel/HBoxContainer/ControlToggle.text = "Hide Controls"
	else:
		$MenuPanel/HBoxContainer/ControlToggle.text = "Show Controls"

func show_loss_screen():
	hide_menu_buttons()
	$MenuPanel.show()
	_set_control_visibility(false)
	$MenuPanel/HBoxContainer/TitleContainer/Label.text = "You have been caught!"
	$MenuPanel/HBoxContainer/MenuSections/MenuButtons/WinLossMenu.show()
