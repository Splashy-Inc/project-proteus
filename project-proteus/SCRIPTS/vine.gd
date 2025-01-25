extends Target


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_collision_layer = collision_layer
	type = Globals.Type.SLASHING
	is_destructible = true
	is_obstacle = true
	_update_collision_layer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _die():
	$CollisionShape2D.disabled = true
	died.emit()
	for piece in $Pieces.get_children():
		if piece is RigidBody2D:
			piece.reparent(get_parent())
			piece.freeze = false
			var player = get_tree().get_nodes_in_group("player").front()
			if player:
				if player.global_position.x > global_position.x:
					piece.apply_impulse(Vector2(piece.mass * -600,0))
				else:
					piece.apply_impulse(Vector2(piece.mass * 600,0))
