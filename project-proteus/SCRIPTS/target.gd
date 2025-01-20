extends StaticBody2D

class_name Target

signal died

@export var type: Globals.Type
@export var is_destructible = false
@export var is_obstacle = false
var default_collision_layer: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = Globals.Type.keys()[type]
	default_collision_layer = collision_layer
	if type == Globals.Type.NONE:
		randomize_self()
	_update_collision_layer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_hit(attack: Attack):
	if attack.type == type:
		if is_destructible:
			call_deferred("_die")
		else:
			print(self, " hit")
		return true
	return false
	
func _die():
	$CollisionShape2D.disabled = true
	died.emit()
	queue_free()
	
func initialize(new_type: Globals.Type, enable_destructible: bool, enable_obstacle: bool):
	type = new_type
	is_destructible = enable_destructible
	is_obstacle = enable_obstacle
	update_configuration()

func update_configuration():
	_update_collision_layer()
	if is_obstacle:
		is_destructible = true
	$Label.text = Globals.Type.keys()[type]
	
func _update_collision_layer():
	collision_layer = default_collision_layer
	if is_obstacle:
		collision_layer |= Globals.CollisionLayer.OBSTACLE
		
func randomize_self():
	var rand_type = randi_range(Globals.Type.SLASHING, Globals.Type.BLUDGEONING)
	var rand_obstacle = bool(randi_range(0,1))
	initialize(rand_type, true, true) # Always destructible obstacle for now
