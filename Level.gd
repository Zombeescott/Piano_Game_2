extends Control


@export var piano : ColorRect

var queue: Array = []
var incorrect: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_midi_player_midi_event(channel: Variant, event: Variant) -> void:
	if channel.number == 0:
		if "note" in event:
			var key : PianoKey = piano.piano_key_dict[event.note]
			print("note: ", event.note)
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
		#print("Note: ", note.get_parent().name, " | Queue: ", queue[0].get_parent().name)
		if note == queue[0]:
			print("Correct")
			queue.pop_front()
			$MidiPlayer.playing = true
			for i in incorrect:
				i.parent.deactivate()
		else:
			print("Incorrect")
			note.parent.color_timer.stop()
			note.color = (Color.RED + note.parent.start_color) / 2
			incorrect.push_back(note)


func _on_current_note_pressed() -> void:
	if queue:
		queue[0].get_parent().play_sound()


func _on_reference_note_pressed() -> void:
	piano.piano_key_dict[60].play_sound()
