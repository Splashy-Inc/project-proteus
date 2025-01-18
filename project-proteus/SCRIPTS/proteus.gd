extends CharacterBody2D


const SPEED = 300.0
const JUMP_HEIGHT = 128 # Pixels high that the player should be able to jump
const JUMP_TIME = .5 # How long the player should take to jump

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() / JUMP_TIME * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		# Give an impule that resolves over JUMP_TIME and peak at JUMP_HEIGHT based on current gravity
		velocity.y = -sqrt(2 * JUMP_HEIGHT * get_gravity().y / JUMP_TIME)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
