extends Camera3D

# The target to follow
@onready var target : Node = $"../playerNode/boat"
var distance = 10.0
var rotation_speed = 1.0
# Speed at which the camera follows the target
var follow_speed = 5.0
@onready var nuTarget: Vector3 = $"../playerNode/boat".global_position + Vector3(3,3,0)
var curAngle : float = 0
@onready var target_rotation : Vector3 = Vector3.ONE
var rotating = false

func _ready():
	global_position = target.global_transform.origin + Vector3(3,3,0)
	#nuTarget = target.global_transform.origin + Vector3(3,3,0)

func _process(delta):
	
	if Input.is_action_pressed("left"):
		#rotate_y(rotation_speed * delta)
		rotating = true
	if Input.is_action_pressed("right"):
		#rotate_y(-rotation_speed * delta)
		rotating = true
		
	if Input.is_action_just_released("left"):
		#dcurAngle = 0
		rotating = false
	if Input.is_action_just_released("right"):
		#curAngle = 0
		rotating = false
	# Check if there is a target

		
	if rotating:
		var initial_distance = 1.0
	# Calculate rotation
		var angle_rad = curAngle * PI / 180
		#print("curtAngle: ", curAngle)
		var x = global_position.x - target.global_position.x
		var z = global_position.z - target.global_position.z
		var x_new = x * cos(angle_rad) - z * sin(angle_rad)
		var z_new = x * sin(angle_rad) + z * cos(angle_rad)

		# Calculate new position maintaining distance
		var new_distance = sqrt(x_new * x_new + z_new * z_new)
		var scale_factor = initial_distance
		#x_new *= scale_factor
		#z_new *= scale_factor

		# Translate back to original position
		x_new += target.global_position.x
		z_new += target.global_position.z
		
		#nuTarget = Vector3(x_new,global_position.y,z_new);
		
	
	if target != null:
	# Get the target's global position
		var roteVec = rotateCall(curAngle)
		var target_global_position = roteVec
#
		## Interpolate between current position and target position
		var new_position = global_position.lerp(target_global_position ,follow_speed * delta ) 
#
		## Set the camera's position to the interpolated position
		global_transform.origin = new_position 
		#global_transform.origin = rotateCall(curAngle)
	look_at(target.global_position + Vector3(0,3,0))
	

func rotate_y_axis(angle):
	#if curAngle >= 100 or curAngle <= -100:
	#	curAngle = curAngle
	#else:
	curAngle += angle
	#print("curAn: ", curAngle)

func rotateCall(angle):
	var relativePosition = Vector3(3,-3,0)# target.global_transform.origin - global_transform.origin
	
	relativePosition = relativePosition.rotated(Vector3.UP, deg_to_rad(curAngle))
	return target.global_transform.origin - relativePosition
	#target_rotation = relativePosition
	#	return relativePosition
	#curAngle += angle;
	##print("angle: ", angle)
	#curAngle = deg_to_rad(curAngle)
	#global_transform.origin.z += curAngle
	# Calculate initial distance between object and center
