class_name PianoKey
extends Control


signal key_pressed(key)

var pitch_scale: float

@onready var key: ColorRect = $Key
@onready var start_color: Color = key.color
@onready var color_timer: Timer = $ColorTimer


func _ready() -> void:
	var level = get_tree().root.get_node("Level")
	if level:
		var callable = Callable(level, "_on_note_played")
		connect("key_pressed", callable)


func setup(pitch_index: int):
	name = "PianoKey" + str(pitch_index)
	var exponent := (pitch_index - 69.0) / 12.0
	pitch_scale = pow(2, exponent)


# Only play the sound
func play_sound():
	var audio := AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = preload("res://piano_keys/A440.wav")
	audio.pitch_scale = pitch_scale
	audio.play()
	await get_tree().create_timer(8.0).timeout
	audio.queue_free()


func activate():
	key.color = (Color.GREEN + start_color) / 2
	#TODO: check if it is a playing mode or smtn
	#color_timer.start()
	play_sound()
	print("Key Pressed: ", key.get_parent().name)
	self.emit_signal("key_pressed", key)


func deactivate():
	key.color = start_color
