extends RigidBody2D

var shape: String

func _ready():
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
	if position.y > 1600:
		queue_free()
