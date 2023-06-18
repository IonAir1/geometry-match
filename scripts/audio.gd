extends Node

var sound_on: bool = true
var override_sound: bool = false

func sound(sound):
	if sound_on and not override_sound:
		get_node(sound).play()
