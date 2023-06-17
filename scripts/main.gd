extends Node2D

var healing: bool = false


func _ready():
	Global.score = 0
	Global.health = 10


func _process(delta):
	$score.text = str(Global.score)
	$health.value = Global.health
	if Global.health <= 0:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_square_body_entered(body):
	if body.shape == 'square':
		Global.score += 1
	else:
		Global.health -= 1
		if not healing:
			heal()
	body.queue_free()


func _on_circle_body_entered(body):
	if body.shape == 'circle':
		Global.score += 1
	else:
		Global.health -= 1
		if not healing:
			heal()
	body.queue_free()


func _on_triangle_body_entered(body):
	if body.shape == 'triangle':
		Global.score += 1
	else:
		Global.health -= 1
		if not healing:
			heal()
	body.queue_free()


func heal():
	healing = true
	await get_tree().create_timer(7).timeout
	if Global.health < 10:
		Global.health += 1
	if Global.health < 10:
		heal()
	else:
		healing = false
