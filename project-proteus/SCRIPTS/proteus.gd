extends CharacterBody2D


const SPEED = Globals.TILE_SIZE.x * 4
const JUMP_TIME = .5 # How long the player should take to jump

var direction = 0.0

enum State {
	IDLE,
	MOVING,
	ATTACKING,
}

var state: State

var right_attack_center := Vector2.ZERO
var attack_type: Globals.Type

@export var attack_scene: PackedScene

var state_machine: AnimationNodeStateMachinePlayback
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	right_attack_center = $AttackCenter.position
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() / JUMP_TIME * delta
		
	match state:
		State.IDLE:
			_move_state(delta)
		State.MOVING:
			_move_state(delta)
		State.ATTACKING:
			_move_state(delta)
			_attack_state()

	
func _move_state(delta: float):
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
		state_machine.travel("idle")
	elif is_on_floor():
		state_machine.travel("run")
	
	move_and_slide()
	
func _attack_state():
	match attack_type:
		Globals.Type.SLASHING:
			state_machine.travel("sword_attack")
		Globals.Type.BLUDGEONING:
			state_machine.travel("hammer_attack")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("slash"):
		attack_type = Globals.Type.SLASHING
		state = State.ATTACKING
	elif event.is_action_pressed("bludgeon"):
		attack_type = Globals.Type.BLUDGEONING
		state = State.ATTACKING

func _attack():
	if $AttackCenter.get_children().is_empty():
		var new_attack = attack_scene.instantiate()
		if new_attack is Attack:
			$AttackCenter.add_child(new_attack)
			new_attack.initialize(attack_type)
			attack_type = Globals.Type.NONE
			state = State.IDLE

func _set_direction(new_direction: float):
		direction = ceil(new_direction)
		if direction != 0:
			$AnimatedSprite2D.flip_h = direction < 0
			$AttackCenter.position = right_attack_center * direction
