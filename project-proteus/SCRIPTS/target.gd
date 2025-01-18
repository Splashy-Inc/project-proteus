extends StaticBody2D

class_name Target

signal died

@export var type: Globals.Type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_hit(attack: Attack):
	if attack.type == type:
		_die()
		return true
	return false
	
func _die():
	print(self, " died")
	died.emit()
