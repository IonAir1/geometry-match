extends RigidBody2D


var shape: String
var healing: bool
var freezing: bool
var main_menu: bool


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
	get_tree().root.connect("size_changed", self._on_viewport_size_changed)


func _process(delta):
	if main_menu:
		if position.y > 1400:
			queue_free()


func _on_viewport_size_changed():
	pass
#	global_transform.origin = get_parent().get_parent().position + position
	
