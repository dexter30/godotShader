extends RigidBody3D


@export var float_force :float = 1

@onready var gravity: float = 9.8
@onready var water = get_node("../../poseidon")
@onready var probes = $probeContainer.get_children()

@export var water_drag := 0.05
@export var water_angular_drag := 0.05



const water_height = 0.0

var submerged := false
@onready var targ = $"../../Camera3D"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#var rigidBoat = $"." as RigidBody3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	submerged = false
	for mark in probes:
		var depth = water.get_height(global_position) - mark.global_position.y#water_height - global_position.y
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * depth* gravity ,mark.global_position - global_position)
		
func _integrate_forces(state: PhysicsDirectBodyState3D):
	#if targ:
		#var target_position =  global_position -  targ.get_global_transform().origin
		#look_follow(state, get_global_transform(), target_position)
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag


#func look_follow(state, current_transform, target_position):
	#var up_dir = Vector3(0, 1, 0)
	#var cur_dir = current_transform.basis * Vector3(0, 0, 1)
	#var target_dir = (target_position - current_transform.origin).normalized()
	#var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
	#print( "currx: ", cur_dir.x)
	#state.set_angular_velocity(up_dir * ( (rotation_angle) / state.get_step()))
	
