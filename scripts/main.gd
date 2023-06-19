extends Node2D


var pressing: bool
var touch_index: int


func _ready():
	$Camera2D.position = ((get_viewport().get_visible_rect().size/Vector2(2,1))-Vector2(360,1280))*-1
	add_child(preload("res://scenes/main_menu.tscn").instantiate())


func _process(delta):
	$Camera2D.position = ((get_viewport().get_visible_rect().size/Vector2(2,1))-Vector2(360,1280))*-1


func _input(ev):
	if "index" in ev:
		if ev.index == touch_index:
			$particles.global_position = ev.position + $Camera2D.position
	if ev is InputEventScreenTouch:
		$particles.global_position = ev.position + $Camera2D.position
		touch_index = ev.index
		if ev.is_pressed() and not pressing:
			pressing = true
			$particles.emitting = true
			Audio.sound("select")
		else:
			pressing = false
			$particles.emitting = false
