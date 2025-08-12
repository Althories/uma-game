extends Sprite2D

@onready var daiwa_area: Area2D = $DaiwaArea	#Reference to Area2D child
@onready var player: CharacterBody2D = %Player	#Reference to player in scene
@onready var interact_key_ui: AnimatedSprite2D = $Interact_Key_UI

var can_interact = true
var player_in_range = false
var talked_yet = false	#Checks whether npc has interacted with the player yet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range and can_interact:
		if not talked_yet:
			DialogueManager.show_dialogue_balloon(load("res://Dialogue/daiwascarlet.dialogue"), "start")
			talked_yet = true
		else:
			DialogueManager.show_dialogue_balloon(load("res://Dialogue/daiwascarlet.dialogue"), "loop")
		Globalvars.dialogue_ended = false
		can_interact = false
		player.can_move = false
	elif Globalvars.dialogue_ended:
		can_interact = true
		
	if player_in_range and can_interact and Globalvars.dialogue_ended:
		interact_key_ui.show()
		interact_key_ui.play("interact")
	else:
		interact_key_ui.hide()
	

func _on_body_entered(_body: Node2D) -> void:
	player_in_range = true

func _on_body_exited(_body: Node2D) -> void:
	player_in_range = false
