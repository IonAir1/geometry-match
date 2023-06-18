extends Node2D

var healing: bool
var lost: bool
var max_health: int = 5
var heal_time: int = 5


func _ready():
	position = Vector2((get_viewport().get_visible_rect().size/Vector2(2,1))-Vector2(360,1280))
	Global.freeze = false
	Global.score = 0
	Global.health = max_health
	$health.max_value = max_health
	$freeze.visible = false
	$fade.visible = false


func _process(delta):
	position = Vector2((get_viewport().get_visible_rect().size/Vector2(2,1))-Vector2(360,1280))
	$particles.global_position = $balls.touch_position
	$score.text = str(Global.score)
	create_tween().tween_property($health, "value", Global.health, 0.2).set_trans(Tween.TRANS_SINE)
	if Global.health <= 0 and not lost:
		lost = true
		$fade.visible = true
		$fade.modulate.a = 0
		Audio.sound("gameover")
		Audio.override_sound = true
		await create_tween().parallel().tween_property($fade, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_SINE).finished
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_square_body_entered(body):
	if body.shape == 'square':
		Global.score += 1
		if body.healing:
			Global.health = max_health
			Audio.sound("heal")
		if body.freezing:
			freeze()
	else:
		Global.health -= 1
		if not healing:
			heal()
		Audio.sound("hurt")
	body.queue_free()


func _on_circle_body_entered(body):
	if body.shape == 'circle':
		Global.score += 1
		if body.freezing:
			freeze()
		if body.healing:
			Global.health = max_health
			Audio.sound("heal")
	else:
		Global.health -= 1
		if not healing:
			heal()
		Audio.sound("hurt")
	body.queue_free()


func _on_triangle_body_entered(body):
	if body.shape == 'triangle':
		Global.score += 1
		if body.freezing:
			freeze()
		if body.healing:
			Global.health = max_health
			Audio.sound("heal")
	else:
		Global.health -= 1
		if not healing:
			heal()
		Audio.sound("hurt")
	body.queue_free()


func heal():
	healing = true
	await get_tree().create_timer(heal_time).timeout
	if Global.health < 10:
		Global.health += 1
	if Global.health < 10:
		heal()
	else:
		healing = false


func freeze():
	if not Global.freeze:
		Global.freeze = true
		Audio.sound("freeze")
		$balls.freeze()
