extends Control

var story_lines = [
	"Long ago, the sun and moon danced in harmony...",
	"But the darkness has grown hungry.",
	"The Eternal Eclipse has begun.",
	"If the light is lost, never-ending night will fall, and the Beasts of Darkness shall reign supreme.",
	"You, the Warrior of Light, awaken in the Surya Mandala.",
	"Venture forth to the Temples of Fire, Water, Earth, and Lightning.",
	"Retrieve their Jewels and offer them to the statue of Lord Surya here.",
	"Only then will the shadow be banished.",
	"You have [color=red]15 minutes[/color] before the world is lost forever."
]

var current_line_index = 0
var is_fading_out = false 
var typing_tween: Tween 
var current_voice_id = "" # Store the ID of the robot voice

@onready var text_label = $RichTextLabel # Ensure this matches your node name!
@onready var prompt_label = $PromptLabel

func _ready():
	# 1. SETUP TTS (Find a Voice)
	var voices = DisplayServer.tts_get_voices_for_language("en") # Get English voices
	if voices.size() > 0:
		current_voice_id = voices[0] # Pick the first available English voice
	
	# Initial Visual Setup
	text_label.modulate.a = 1.0
	text_label.visible_ratio = 0.0
	prompt_label.modulate.a = 0.0 
	show_line()

func _input(event):
	# ESC to Skip
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		stop_talking() # Stop audio if skipping
		start_game()
		return

	# Space/Click to Advance
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.is_pressed()):
		if text_label.visible_ratio < 1.0:
			finish_typing_instantly()
		elif not is_fading_out:
			fade_out_and_next()

func show_line():
	# 1. Visual Text
	var clean_text = story_lines[current_line_index]
	text_label.text = "[center]" + clean_text + "[/center]"
	text_label.visible_ratio = 0.0
	text_label.modulate.a = 1.0
	prompt_label.modulate.a = 0.0
	is_fading_out = false
	
	# 2. AUDIO: Speak the text!
	# We strip the BBCode tags because we don't want the robot saying "bracket color equals red bracket"
	var spoken_text = clean_text.replace("[color=red]", "").replace("[/color]", "")
	
	stop_talking() # Stop previous sentence
	if current_voice_id != "":
		# Speak(Text, VoiceID, Volume, Pitch, Rate)
		DisplayServer.tts_speak(spoken_text, current_voice_id, 50, 0.9, 0.8)

	# 3. Animation
	var duration = text_label.get_total_character_count() * 0.05
	
	if typing_tween: typing_tween.kill()
	typing_tween = create_tween()
	typing_tween.tween_property(text_label, "visible_ratio", 1.0, duration)
	typing_tween.tween_callback(fade_in_prompt)

func stop_talking():
	DisplayServer.tts_stop()

func fade_in_prompt():
	var prompt_tween = create_tween()
	prompt_tween.tween_property(prompt_label, "modulate:a", 1.0, 0.5)

func finish_typing_instantly():
	if typing_tween: typing_tween.kill()
	text_label.visible_ratio = 1.0
	prompt_label.modulate.a = 1.0

func fade_out_and_next():
	stop_talking() # Stop audio when fading out
	is_fading_out = true
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(text_label, "modulate:a", 0.0, 0.5)
	tween.tween_property(prompt_label, "modulate:a", 0.0, 0.5)
	tween.chain().tween_callback(load_next_line)

func load_next_line():
	current_line_index += 1
	if current_line_index < story_lines.size():
		show_line()
	else:
		start_game()

func start_game():
	stop_talking() # Final safety stop
	GlobalClock.start_timer()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
