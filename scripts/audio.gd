extends Node

var sound_on: bool = true
var music_on:bool = true
var override_sound: bool
var music_time: float

func sound(sound):
	if sound_on and not override_sound:
		get_node(sound).play()


func _ready():
	$music.play()


func _on_music_finished():
	$music.play()


func update_music_volume():
	if music_on:
		music_on = false
		music_time = $music.get_playback_position()
		$music.stop()
	else:
		music_on = true
		$music.play()
		$music.seek(music_time)
