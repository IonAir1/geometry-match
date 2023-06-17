extends Node2D

var started: bool = false

func _ready():
	$walls.position.y = 500


func _process(delta):
	if started:
		if $walls.position.y > 0:
			$walls.position.y -= 10
		else:
			get_tree().change_scene_to_file("res://scenes/main.tscn")


func _input(event):
	if event.is_pressed():
		started = true
