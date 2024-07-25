extends Button


@export var song_name: String
@export var song_file: String

var level: PackedScene = preload("res://Level.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if song_name:
		$Button.text = song_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	print("Song Selected")
	var level_instance = level.instantiate()
	if song_file:
		level_instance.song = song_file
	get_tree().root.add_child(level_instance)
