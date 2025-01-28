extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$TextureRect/Sprite2D2/AnimationPlayer.play("speaking")


func _on_timer_2_timeout() -> void:
	$AnimationPlayer.play("run_away")
