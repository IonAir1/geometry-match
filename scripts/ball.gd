extends RigidBody2D


var shape: String
var healing: bool = false
var freezing: bool = false
var main_menu: bool = false


func _ready():
	if freezing:
		$ball_mesh.texture = preload("res://textures/white.tres")
		$square_mesh.texture = preload("res://textures/white.tres")
		$triangle_mesh.texture = preload("res://textures/white.tres")
	if healing:
		$heal.visible = true
	else:
		$heal.visible = false
	if shape == 'circle':
		$square_mesh.queue_free()
		$square_collision.queue_free()
		$triangle_mesh.queue_free()
		$triangle_collision.queue_free()
	elif shape == 'square':
		$ball_mesh.queue_free()
		$ball_collision.queue_free()
		$triangle_mesh.queue_free()
		$triangle_collision.queue_free()
	elif shape == 'triangle':
		$ball_mesh.queue_free()
		$ball_collision.queue_free()
		$square_mesh.queue_free()
		$square_collision.queue_free()
	rotation_degrees = randi()%360
	angular_velocity = randf_range(-7, 7)

func _process(delta):
	if main_menu:
		if position.y > 1400:
			queue_free()
