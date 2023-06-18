extends Node2D


var started: bool
var min_time: int = 0.5
var max_time: int = 1
var ball: PackedScene = preload("res://scenes/ball.tscn")
var pressing: bool
var touch_position: Vector2
var touch_index: int


func _ready():
	position = Vector2((get_viewport().get_visible_rect().size/Vector2(2,1))-Vector2(360,1280))
	$particles.global_position = touch_position

	if Global.score > Global.high_score:
		Global.high_score = Global.score
		Leaderboard._upload_score(Global.score)
	
	if Audio.music_on:
		$scores/music.modulate = Color(1, 1, 1, 1)
	else:
		$scores/music.modulate = Color(0.2, 0.2, 0.2, 1)
	if Audio.sound_on:
		$scores/sound.modulate = Color(1, 1, 1, 1)
	else:
		$scores/sound.modulate = Color(0.2, 0.2, 0.2, 1)
	
	Audio.override_sound = false
	Global.freeze = false
	$scores.modulate.a = 1
	$walls.position.y = 750
	$fade.visible = true
	$fade.modulate.a = 1
	await create_tween().parallel().tween_property($fade, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_SINE).finished
	$fade.visible = false
	await get_tree().create_timer(randf_range(min_time, max_time)).timeout
	spawn()


func _process(delta):
	position = Vector2((get_viewport().get_visible_rect().size/Vector2(2,1))-Vector2(360,1280))
	$particles.global_position = touch_position
	$scores/score.text = "Score: " + str(Global.score)
	$scores/highscore.text = "Best Score: " + str(Global.high_score)
	$scores/leaderboard.text = "Leaderboard\n" + str(Leaderboard.leaderboard_formatted)


func _input(ev):
	if "index" in ev:
		if ev.index == touch_index:
			touch_position = ev.position
	if ev is InputEventScreenTouch:
		touch_position = ev.position
		touch_index = ev.index
		if ev.is_pressed() and not pressing:
			pressing = true
			$particles.emitting = true
			Audio.sound("select")
		else:
			pressing = false
			$particles.emitting = false


func _on_play_input_event(viewport, event, shape_idx):
	if event.is_pressed() and  not started:
		started = true
		await create_tween().parallel().tween_property($scores, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_SINE).finished
		while $balls.get_child_count() > 0:
			await get_tree().create_timer(0.1).timeout
		await create_tween().parallel().tween_property($walls, "position:y", 0, 2).set_trans(Tween.TRANS_QUART).finished
		get_tree().change_scene_to_file("res://scenes/main.tscn")


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
	b.main_menu = true
	if not started:
		$balls.add_child(b)
		await get_tree().create_timer(randf_range(min_time, max_time)).timeout
		spawn()


func _on_sound_pressed():
	if Audio.sound_on:
		Audio.sound_on = false
		$scores/sound.modulate = Color(0.2, 0.2, 0.2, 1)
	else:
		Audio.sound_on = true
		$scores/sound.modulate = Color(1, 1, 1, 1)


func _on_music_pressed():
	Audio.update_music_volume()
	if Audio.music_on:
		$scores/music.modulate = Color(1, 1, 1, 1)
	else:
		$scores/music.modulate = Color(0.2, 0.2, 0.2, 1)
