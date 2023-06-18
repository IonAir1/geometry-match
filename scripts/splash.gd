extends Node2D

func _ready():
	$fade.visible = true
	$fade.modulate.a = 1
	await await create_tween().parallel().tween_property($fade, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_SINE).finished
	await get_tree().create_timer(3).timeout
	await await create_tween().parallel().tween_property($fade, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_SINE).finished
	Audio.sound("music")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _process(delta):
	position = Vector2((get_viewport().get_visible_rect().size/Vector2(2,1))-Vector2(360,1280))
