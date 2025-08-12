extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

var can_interact = true		#for re-initiating dialogue in process
var can_move = true			#for player input movement physics process

@onready var player_sprite: Sprite2D = $PlayerSprite

func _process(_delta: float) -> void:
	#Allow dialogue interaction
	if Input.is_action_just_pressed("interact") and can_interact == true:
		DialogueManager.show_dialogue_balloon(load("res://Dialogue/test_dialogue.dialogue"), "start")
		Globalvars.dialogue_ended = false
		can_interact = false
		can_move = false
	elif Globalvars.dialogue_ended:
		can_interact = true
		
		
	#Faces Player Sprite in appropriate direction based on movement direction
	if Globalvars.dialogue_ended:
		if Input.is_action_just_pressed("move_left"):
			player_sprite.flip_h = true
		elif Input.is_action_just_pressed("move_right"):
			player_sprite.flip_h = false
		
		

func _physics_process(delta: float) -> void:
	#Player movement block - if player is not in dialogue
	if can_move:
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
	
	#put at bottom to prevent accidental jump upon dialogue end with SPACE
	if Globalvars.dialogue_ended:
		@warning_ignore("standalone_expression")	#it does have an effect, actually :nerd:
		can_move == true

		move_and_slide()
