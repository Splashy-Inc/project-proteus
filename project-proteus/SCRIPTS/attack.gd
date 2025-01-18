extends Area2D

class_name Attack

enum Type {
	NONE,
	SLASHING,
	BLUDGEONING,
}

var type = Type.NONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initialize(new_type: Type):
	type = new_type
