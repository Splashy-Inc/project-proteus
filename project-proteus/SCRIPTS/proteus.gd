extends CharacterBody2D


const SPEED = 300.0
const JUMP_TIME = .5 # How long the player should take to jump

var direction = 0.0
var right_attack_center := Vector2.ZERO

@export var attack_scene: PackedScene

func _ready():
	right_attack_center = $AttackCenter.position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() / JUMP_TIME * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		# Give an impule that resolves over JUMP_TIME and peak at JUMP_HEIGHT based on current gravity
		velocity.y = -sqrt(2 * Globals.PLAYER_JUMP_HEIGHT * get_gravity().y / JUMP_TIME)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	_set_direction(Input.get_axis("left", "right"))
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.x == 0:
		$AnimatedSprite2D.play("Idle")
	elif is_on_floor():
		$AnimatedSprite2D.play("Run")
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("slash"):
		_attack(Globals.Type.SLASHING)
	elif event.is_action_pressed("bludgeon"):
		_attack(Globals.Type.BLUDGEONING)

func _attack(attack_type: Globals.Type):
	if $AttackCenter.get_children().is_empty():
		var new_attack = attack_scene.instantiate()
		if new_attack is Attack:
			$AttackCenter.add_child(new_attack)
			new_attack.initialize(attack_type)

func _set_direction(new_direction: float):
		direction = ceil(new_direction)
		if direction != 0:
			$AnimatedSprite2D.flip_h = direction < 0
			$AttackCenter.position = right_attack_center * direction
