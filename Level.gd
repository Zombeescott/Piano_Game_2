extends Control


@onready var midi_player : MidiPlayer = $MidiPlayer
@onready var start_timer : Timer = $background/StartTimer
@onready var start_label : RichTextLabel = $background/StartTimer/TimerLabel
@onready var time_label : RichTextLabel = $background/TimeLabel

@export var piano : ColorRect
@export var song: String

var level_select: PackedScene = load("res://level_select.tscn")
var queue: Array = []
var incorrect: Array = []
var elapsed_time: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_timer.start()
	if song:
		midi_player.file = song


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_label.text == "0":
		# Hide label once not needed
		if elapsed_time == 0:
			start_label.hide()
		elapsed_time += delta
		time_label.text = str(round(elapsed_time * 100) / 100.0)
		
	elif start_label.text != str(ceil(start_timer.time_left)):
		start_label.text = str(ceil(start_timer.time_left))


func _on_midi_player_midi_event(channel: Variant, event: Variant) -> void:
	if channel.number == 0 and "note" in event:
		var key : PianoKey = piano.piano_key_dict[event.note]
		match event.type:
			SMF.MIDIEventType.note_off:
				pass
				#key.deactivate()
			SMF.MIDIEventType.note_on:
				key.play_sound()
				queue.push_back(key.get_child(0))
				#print("Queued: ", key)
				$MidiPlayer.playing = false


func _on_note_played(note: ColorRect) -> void:
	if queue:
		if note == queue[0]:
			#print("Correct")
			queue.pop_front()
			$MidiPlayer.playing = true
			note.parent.color_timer.start()
			# Clear incorrect queue
			for i in incorrect:
				i.parent.deactivate()
			incorrect = []
		else:
			#print("Incorrect")
			#note.parent.color_timer.set_paused(true)
			note.color = (Color.RED + note.parent.start_color) / 2
			incorrect.push_back(note)


func _on_current_note_pressed() -> void:
	if queue:
		queue[0].get_parent().play_sound()


func _on_reference_note_pressed() -> void:
	piano.piano_key_dict[60].play_sound()


func _on_midi_player_finished() -> void:
	print("Song Finished")
	get_tree().change_scene_to_packed(level_select)


func _on_start_timer_timeout() -> void:
	$MidiPlayer.play()
