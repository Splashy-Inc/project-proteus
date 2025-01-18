extends Area2D

class_name Attack

var type = Globals.Type.NONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initialize(new_type: Globals.Type):
	type = new_type

func _on_body_entered(body: Node2D) -> void:
	if body is Target:
		if body.on_hit(self):
			print("Successful hit!")
		else:
			print("Failed hit...")
