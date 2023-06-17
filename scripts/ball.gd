extends RigidBody2D

var shape = 0

func _ready():
	if shape == 0:
		$square_mesh.queue_free()
		$square_collision.queue_free()
		$triangle_mesh.queue_free()
		$triangle_collision.queue_free()
	elif shape == 1:
		$ball_mesh.queue_free()
		$ball_collision.queue_free()
		$triangle_mesh.queue_free()
		$triangle_collision.queue_free()
	elif shape == 2:
		$ball_mesh.queue_free()
		$ball_collision.queue_free()
		$square_mesh.queue_free()
		$square_collision.queue_free()
	rotation_degrees = randi()%360
	angular_velocity = randf_range(-7, 7)

func _process(delta):
	if position.y > 1400:
		queue_free()
