extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var player_sprite: Sprite2D = $PlayerSprite

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		DialogueManager.show_dialogue_balloon(load("res://Dialogue/test_dialogue.dialogue"), "start")
		
	#Faces Player Sprite in appropriate direction based on movement direction
	if Input.is_action_just_pressed("move_left"):
		player_sprite.flip_h = true
	elif Input.is_action_just_pressed("move_right"):
		player_sprite.flip_h = false
		
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
