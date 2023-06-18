extends Node2D


var started: bool = false
var min_time: int = 0.5
var max_time: int = 1
var ball: PackedScene = preload("res://scenes/ball.tscn")


func _ready():

	if Global.score > Global.high_score:
		Global.high_score = Global.score
		Leaderboard._upload_score(Global.score)

	Audio.override_sound = false
	Global.freeze = false
	$scores.modulate.a = 1
	$walls.position.y = 380
	$fade.visible = true
	$fade.modulate.a = 1
	await create_tween().parallel().tween_property($fade, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_SINE).finished
	$fade.visible = false
	await get_tree().create_timer(randf_range(min_time, max_time)).timeout
	spawn()


func _process(delta):
	$scores/score.text = "Score: " + str(Global.score)
	$scores/leaderboard.text = "Leaderboard\n" + str(Leaderboard.leaderboard_formatted)


func _input(event):
	if event.is_pressed():
		Audio.sound("select")


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


func _on_music_toggled(button_pressed):
	pass # Replace with function body.


func _on_sound_pressed():
	if Audio.sound_on:
		Audio.sound_on = false
		$scores/sound.modulate = Color(0.2, 0.2, 0.2, 1)
	else:
		Audio.sound_on = true
		$scores/sound.modulate = Color(1, 1, 1, 1)


func _on_music_pressed():
	if Audio.music_on:
		Audio.music_on = false
		$scores/music.modulate = Color(0.2, 0.2, 0.2, 1)
	else:
		Audio.music_on = true
		$scores/music.modulate = Color(1, 1, 1, 1)
