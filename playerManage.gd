extends Node3D

@onready var rb :RigidBody3D = $boat
@onready var cam = $"../Camera3D"
@onready var ocean = $"../poseidon"
@onready var joy = $"../CanvasLayer/HBoxContainer/joy"
@onready var joy2 = $"../CanvasLayer/HBoxContainer2/joy2"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var speed = 10
var rotation_speed = 3
var gravity = -9.8

var angleC = 1.0;

func _physics_process(delta):
	var direction = Vector3(0, 0, 0)

	# Applying gravity
	#direction.y += gravity
	var forward = Vector3(global_position - cam.global_position ).normalized()
	# Movement based on keyboard input
	direction += Vector3(-joy.posVector.y,0.0,joy.posVector.x)* speed * delta
	cam.rotate_y_axis(-joy2.posVector.x* 100 * delta)
	if Input.is_action_pressed("forward"):
		direction += forward * speed * delta
	if Input.is_action_pressed("backward"):
		direction += -forward * speed * delta
	if Input.is_action_pressed("left"):
		#rotate_y(rotation_speed * delta)
		cam.rotate_y_axis(angleC)
		#look_at(cam.global_position - global_position)
	if Input.is_action_pressed("right"):
		#rotate_y(-rotation_speed * delta)
		cam.rotate_y_axis(-angleC)
		#look_at(cam.global_position - global_position)
	direction = Vector3(direction.x,0.0,direction.z)
	ocean.position = self.position - Vector3(0.0,1.0,0.0)
	# Applying force
	global_transform.origin += direction
	updateOrentation()
	
func updateOrentation():
	var a = Quaternion(transform.basis)
	var b = Quaternion(cam.basis)
	# Interpolate using spherical-linear interpolation (SLERP).
	var c = a.slerp(b,0.5) # find halfway point between a and b
	# Apply back
	transform.basis = Basis(c)


