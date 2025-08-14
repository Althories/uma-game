extends AnimatedSprite2D

@onready var daiwa_area: Area2D = $DaiwaArea	#Reference to Area2D child
@onready var player: CharacterBody2D = %Player	#Reference to player in scene
@onready var interact_key_ui: AnimatedSprite2D = $Interact_Key_UI
@onready var animation_cooldown_timer: Timer = $AnimationCooldownTimer
@onready var animation_blink_timer: Timer = $AnimationBlinkTimer
@onready var daiwa_voice_player: AudioStreamPlayer = $DaiwaVoicePlayer

#For dialogue handling
var can_interact = true
var player_in_range = false
var talked_yet = false	#Checks whether npc has interacted with the player yet

#For animation handling
var can_play_idle_animation = true	#Checks whether Daiwa can play an animation
var can_blink = true	#Checks whether Daiwa's blink anim can be played
var randomly_selected_animation	#initialized here. Will change in script.
var randomly_selected_timer_time #randomly selected amount of time to wait before starting next anim

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Dialogue interaction handling ----------------------
	if Input.is_action_just_pressed("interact") and player_in_range and can_interact:
		if not talked_yet:
			DialogueManager.show_dialogue_balloon(load("res://Dialogue/daiwascarlet.dialogue"), "start", [self])
			talked_yet = true
		else:
			DialogueManager.show_dialogue_balloon(load("res://Dialogue/daiwascarlet.dialogue"), "loop", [self])
		Globalvars.dialogue_ended = false
		can_interact = false
		player.can_move = false
	elif Globalvars.dialogue_ended:
		can_interact = true
		
	#Show/hide interact prompt above sprite
	if player_in_range and can_interact and Globalvars.dialogue_ended:
		interact_key_ui.show()
		interact_key_ui.play("interact")
	else:
		interact_key_ui.hide()
		
	#Animation handling -----------------------------
	if can_play_idle_animation:
		randomly_selected_animation = ["small_crouch", "sway_arms"].pick_random()
		play(randomly_selected_animation)	#plays animation
		can_play_idle_animation = false
	if can_blink and not is_playing():	#Will not interrupt another idle anim to start blink anim
		play("blink")
		animation_blink_timer.start()
		can_blink = false
		
#Misc functions -------------------------------------------------------------------
func play_voice() -> void:
	daiwa_voice_player.play()

#Signal stuff -------------------------------------------------------------------------------
func _on_body_entered(_body: Node2D) -> void:
	player_in_range = true

func _on_body_exited(_body: Node2D) -> void:
	player_in_range = false

func _on_daiwa_enter_body_entered(_body: Node2D) -> void:
	flip_h = true

func _on_daiwa_exit_body_exited(_body: Node2D) -> void:
	flip_h = false

func _on_animation_finished() -> void:
	animation_cooldown_timer.wait_time = randf_range(2.0, 6.0)	#picks a random wait time for the cooldown
	animation_cooldown_timer.start()	#start animation cooldown
	
func _on_animation_cooldown_timer_timeout() -> void:
	can_play_idle_animation = true

func _on_animation_blink_timer_timeout() -> void:
	animation_blink_timer.wait_time = randf_range(2.5, 4.5)	#change the blink timer every time
	can_blink = true
