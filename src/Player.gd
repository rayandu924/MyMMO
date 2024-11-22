extends CharacterBody3D  # Pour Godot 4.x (ou KinematicBody pour Godot 3.x)

var speed = 5.0
var mouse_sensitivity = 0.3

# Ajoutez une limite pour empêcher la caméra de se retourner complètement
var camera_vertical_limit = 90.0  # Limite en degrés
var camera_rotation_x = 0.0  # Rotation verticale accumulée

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Rotation horizontale (Player)
		rotate_y(-event.relative.x * mouse_sensitivity * 0.01)

		# Rotation verticale (Camera3D)
		var vertical_rotation = event.relative.y * mouse_sensitivity * 0.01
		camera_rotation_x = clamp(camera_rotation_x + vertical_rotation, -deg_to_rad(camera_vertical_limit), deg_to_rad(camera_vertical_limit))
		$Camera3D.rotation.x = camera_rotation_x

func _physics_process(_delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x

	direction.y = 0
	direction = direction.normalized()

	velocity = direction * speed
	move_and_slide()
