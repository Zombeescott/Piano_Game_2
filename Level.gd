extends Control


@onready var midi_player : MidiPlayer = $MidiPlayer

@export var piano : ColorRect
@export var song: String
#@export var song: String = "res://Tetris - Tetris Main Theme.mid"

var level_select: PackedScene = load("res://level_select.tscn")
var queue: Array = []
var incorrect: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StartTimer.start()
	if song:
		midi_player.file = song


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $StartTimer/TimerLabel.text == "0":
		$StartTimer/TimerLabel.hide()
	elif $StartTimer/TimerLabel.text != str(ceil($StartTimer.time_left)):
		$StartTimer/TimerLabel.text = str(ceil($StartTimer.time_left))


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
