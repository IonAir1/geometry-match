extends Node2D

var ball: PackedScene = preload("res://scenes/ball.tscn")
var new_pos: Vector2
var offset: Vector2
var status: String
var selected_ball: Object
var time_min: float = 0.2
var time_max: float = 0.5
var heal_min: int = 30
var heal_max: int = 60
var heal_count: int
var freeze_min: int = 40
var freeze_max: int = 80
var freeze_count: int
var touch_position: Vector2
var touch_index: int


func _ready():
	heal_count = randi_range(heal_min, heal_max)
	freeze_count = randi_range(freeze_min, freeze_max)
	await get_tree().create_timer(randf_range(time_min, time_max)).timeout
	spawn()


func _physics_process(delta):
	if status == "dragging" and is_instance_valid(selected_ball):
		selected_ball.global_transform.origin = (touch_position - offset).clamp(Vector2(0,0),Vector2(720,1280))


func _input(ev):
	if "index" in ev:
		if ev.index == touch_index:
			touch_position = ev.position + get_node("../../Camera2D").position
	if ev is InputEventScreenTouch:
		if status != "dragging" and ev.pressed:
			touch_position = ev.position + get_node("../../Camera2D").position
			selected_ball = find_nearest()
			if selected_ball == null:
				return
			selected_ball.freeze = true
			touch_index = ev.index
			status = "clicked"
			offset = touch_position - selected_ball.position
			Audio.sound("select")
		elif not ev.pressed:
			status = "released"
			Audio.sound("drop")
			if not Global.freeze:
				if selected_ball == null:
					return
				selected_ball.freeze = false
	if status == "clicked" and ev is InputEventScreenDrag:
		status = "dragging"


func freeze():
	for i in range(15):
		freeze_spawn()
		await get_tree().create_timer(0.03).timeout
	await get_tree().create_timer(0.7).timeout
	get_parent().get_node("freeze").visible = true
	get_parent().get_node("freeze").modulate.a = 0.25
	for ball in get_children():
		ball.freeze = true
	await get_tree().create_timer(3.25).timeout
	Audio.sound("unfreeze")
	await create_tween().chain().tween_property(get_parent().get_node("freeze"), "modulate:a", 0, 0.25).set_trans(Tween.TRANS_SINE).finished
	await create_tween().chain().tween_property(get_parent().get_node("freeze"), "modulate:a", 0.25, 0.25).set_trans(Tween.TRANS_SINE).finished
	await create_tween().chain().tween_property(get_parent().get_node("freeze"), "modulate:a", 0, 0.25).set_trans(Tween.TRANS_SINE).finished
	await create_tween().chain().tween_property(get_parent().get_node("freeze"), "modulate:a", 0.25, 0.25).set_trans(Tween.TRANS_SINE).finished
	await create_tween().chain().tween_property(get_parent().get_node("freeze"), "modulate:a", 0, 0.25).set_trans(Tween.TRANS_SINE).finished
	await create_tween().chain().tween_property(get_parent().get_node("freeze"), "modulate:a", 0.25, 0.25).set_trans(Tween.TRANS_SINE).finished
	await create_tween().chain().tween_property(get_parent().get_node("freeze"), "modulate:a", 0, 0.25).set_trans(Tween.TRANS_SINE).finished
	await create_tween().chain().tween_property(get_parent().get_node("freeze"), "modulate:a", 0.25, 0.25).set_trans(Tween.TRANS_SINE).finished
	await create_tween().chain().tween_property(get_parent().get_node("freeze"), "modulate:a", 0, 0.25).set_trans(Tween.TRANS_SINE).finished

	Global.freeze = false
	get_parent().get_node("freeze").visible = false
	for ball in get_children():
		ball.freeze = false


func freeze_spawn():
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
	add_child(b)


func spawn():
	if not Global.freeze:
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

			if freeze_count <= 0:
				freeze_count = randi_range(freeze_min, freeze_max)
				b.freezing = true
			else:
				freeze_count -= 1

		add_child(b)
	await get_tree().create_timer(randf_range(time_min, time_max)).timeout
	spawn()


func find_nearest():
	var mouse_pos: Vector2 = touch_position
	var objects: Array
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
