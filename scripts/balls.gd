extends Node2D

var ball: PackedScene = preload("res://scenes/ball.tscn")
var new_pos: Vector2
var offset: Vector2
var status: String
var selected_ball: Object
var min_time: int = 0.5
var max_time: int = 1
var heal_min: int = 10
var heal_max: int = 15
var heal_count: int


func _ready():
	heal_count = randi_range(heal_min, heal_max)
	await get_tree().create_timer(randf_range(min_time, max_time)).timeout
	spawn()


func _physics_process(delta):
	if status == "dragging" and is_instance_valid(selected_ball):
		selected_ball.global_transform.origin = (get_viewport().get_mouse_position() - offset).clamp(Vector2(0,0),Vector2(720,1280))


func _input(ev):
	if ev is InputEventScreenTouch:
		if status != "dragging" and ev.pressed:
			selected_ball = find_nearest()
			if selected_ball == null:
				return
			selected_ball.freeze = true
			status = "clicked"
			offset = ev.position - selected_ball.position
		elif status == "dragging" and not ev.pressed:
			status = "released"
			selected_ball.freeze = false
	if status == "clicked" and ev is InputEventScreenDrag:
		status = "dragging"


func spawn():
	var b: Node2D = ball.instantiate()
	b.position.x = randi_range(50, 675)
	b.position.y = -60
	var shape: int = randi()%3
	if shape == 0:
		b.shape = 'circle'
	elif shape == 1:
		b.shape = 'square'
	elif shape == 2:
		b.shape = 'triangle'
	
	if heal_count <= 0:
		heal_count = randi_range(heal_min, heal_max)
		b.healing = true
	else:
		heal_count -= 1
	
	add_child(b)
	await get_tree().create_timer(randf_range(min_time, max_time)).timeout
	spawn()


func find_nearest():
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var objects: Array = []
	for child in get_children():
		objects.append(child)
	if objects == []:
		return null # Failure case
	if objects.size() == 1:
		return objects[0]
	var near_obj: Object = objects[0]
	var near_pos: Vector2 = near_obj.global_position
	var near_sqr: float = mouse_pos.distance_squared_to(near_pos)
	for i in range(1, objects.size()):
		var obj: Object = objects[i]
		var pos: Vector2 = obj.global_position
		var sqr: float = mouse_pos.distance_squared_to(pos)
		if(sqr < near_sqr):
			near_sqr = sqr
			near_obj = obj
	return near_obj
