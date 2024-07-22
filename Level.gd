extends Control


@export var piano : ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_midi_player_midi_event(channel: Variant, event: Variant) -> void:
	if channel.number == 0:
		#print(event.type)
		#print(event.note)
		if "note" in event:
			var key : PianoKey = piano.piano_key_dict[event.note]
			match event.type:
				SMF.MIDIEventType.note_off:
					key.deactivate()
				SMF.MIDIEventType.note_on:
					#key.activate()
					key.play_sound()
					$MidiPlayer.playing = false


func _on_note_played(note) -> void:
	print("pressed")
