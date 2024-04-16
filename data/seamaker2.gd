#@tool
extends Node3D

var OceanTile = preload("res://seas.tscn");
var spawnPoint = preload("res://data/GridSpawnInfo.tres")

var nuNode = null
var centerTile = null

var cMaterial: ShaderMaterial
var noise: Image

var noiseScale: float
var waveSpeed: float
var heightScale: float
var time:float

func _ready():
	#only use even numbers 
	#too dumb to figure out why odd doesnt works.
	newMethod(16);
	centerTile = get_node("centerTile")
	cMaterial = centerTile.mesh.surface_get_material(0)
	noise = cMaterial.get_shader_parameter("wave").noise.get_seamless_image(512,512)
	noiseScale =  cMaterial.get_shader_parameter("noise_scale")
	heightScale =  cMaterial.get_shader_parameter("height_scale")
	print("height: ", heightScale)
	#waveSpeed = =  cMaterial.get_shader_parameter("wave_speed")

func get_height(worldPos: Vector3) -> float:
	var uv_x = wrapf(worldPos.x /noiseScale + time ,0,1)
	var uv_y = wrapf(worldPos.z /noiseScale + time ,0,1)
	
	var pixelPos = Vector2(uv_x* noise.get_width(),uv_y * noise.get_height())
	return global_position.y + noise.get_pixelv(pixelPos).r * heightScale;

func _process(delta):
	time += delta
	cMaterial.set_shader_parameter("wave_time",time)



func newProcedure():
	print("nothing?3")
	var grid_size = 3
	var center = (grid_size - 1)/2
	var subdivision_max = center *3
	print ("Array Index \tSpawn Point (Vector2)\tSubdivision (Int)\tScale (Int)\t distance")
	
	for y in range(grid_size):
		for x in range(grid_size):
			var spawnPoint = Vector2(x - center, y - center)
			var distance = spawnPoint.distance_to(Vector2(0,0))#spawnPoint.length()
			distance = roundi(distance)
			# Calculate scale and subdivision based on distance
			var scale = 3 - distance  # Adjust this factor as needed
			var subdivision = subdivision_max - distance * 33
	
			# Ensure minimum scale of 1 for outer tiles
			scale = max(1, scale)

			# Calculate offset based on distance
			var offset = (3 - scale) * 0.5  # Offset is exactly the difference in scale

			# Calculate final spawn location by considering the offset
			#var spawnLocation = spawnPoint * scale + spawnPoint.normalized() * offset
			#var spawnLocation = Vector2(round(spawnPoint.x * scale), round(spawnPoint.y * scale))
			#spawnLocation = Vector2(roundi(spawnLocation.x), roundi(spawnLocation.y))
			var offset_x = (3 - scale) * 0.5 * sign(spawnPoint.x)
			var offset_y =  (3 - scale) * 0.5 * sign(spawnPoint.y)

			# Calculate final spawn location by considering the offset
			var spawnLocation = Vector2(round(spawnPoint.x * scale) + offset_x, round(spawnPoint.y * scale) + offset_y)
			
			var tileSubdivision = subdivision#spawnPoint.subdivision[i]
			var tileScale  = scale#spawnPoint.scale[i]
			
			var instance = OceanTile.instantiate()
			add_child(instance)
			instance.owner = self
			
			instance.position = Vector3(spawnLocation.x,0.0,spawnLocation.y) * 10.05
			instance.mesh.set_subdivide_width(tileSubdivision);#
			instance.mesh.set_subdivide_depth(tileSubdivision);
			instance.set_scale(Vector3(tileScale,1.0,tileScale))
			
			
			print ("%d\t\t%s\t\t%d\t\t%f\t\t%f" % [y * grid_size + x, spawnPoint, subdivision, scale,distance])
	


# Called when the script is executed (using File -> Run in Script Editor).
func nope():
	for i in 5:
		print("nothing?4")
		var spawnLocation = spawnPoint.spawnPoints[i]
		var tileSubdivision = spawnPoint.subdivision[i]
		var tileScale  = spawnPoint.scale[i]
		var instance = OceanTile.instantiate()
		
		add_child(instance)
		instance.owner = self
		
		instance.position = Vector3(spawnLocation.x,0.0,spawnLocation.y) * 10.05
		instance.mesh.set_subdivide_width(tileSubdivision);#
		instance.mesh.set_subdivide_depth(tileSubdivision);
		instance.set_scale(Vector3(tileScale,1.0,tileScale))
		
	

func newMethod(grid_size):
	var rim = grid_size*grid_size
	var center = (grid_size - 1)/2
	for i in range(grid_size):
		for j in range(grid_size):
			if i == 0  or i == grid_size -1 or j ==0 or j == grid_size - 1:
				print(Vector2(i - center, j - center))
				var spawnLocation = Vector2(i - center, j - center)#spawnPoint.spawnPoints[i]
				var tileSubdivision = 1#spawnPoint.subdivision[i]
				var tileScale  = 1#spawnPoint.scale[i]
				var instance = OceanTile.instantiate()
				
				add_child(instance)
				instance.owner = self
				
				instance.position = Vector3(spawnLocation.x,0.0,spawnLocation.y) * 10.05
				instance.mesh.set_subdivide_width(tileSubdivision);#
				instance.mesh.set_subdivide_depth(tileSubdivision);
				instance.set_scale(Vector3(tileScale,1.0,tileScale))
			if i == 1  or i == grid_size -2 or j ==1 or j == grid_size - 2:
				var spawnLocation = Vector2(i - center, j - center)#spawnPoint.spawnPoints[i]
				var tileSubdivision = 99#spawnPoint.subdivision[i]
				var tileScale  = 1#spawnPoint.scale[i]
				var instance = OceanTile.instantiate()
				
				add_child(instance)
				instance.owner = self
				
				instance.position = Vector3(spawnLocation.x,0.0,spawnLocation.y) * 10.05
				instance.mesh.set_subdivide_width(tileSubdivision);#
				instance.mesh.set_subdivide_depth(tileSubdivision);
				instance.set_scale(Vector3(tileScale,1.0,tileScale))
	
	var spawnLocation = Vector2(0, 0)#spawnPoint.spawnPoints[i]
	var tileSubdivision = 199#spawnPoint.subdivision[i]
	var tileScale  = grid_size-4#spawnPoint.scale[i]
	var instance = OceanTile.instantiate()
	
	add_child(instance)
	instance.owner = self
	
	instance.position = Vector3(spawnLocation.x+ 10.05/2, 0.0, spawnLocation.y+ 10.05/2)# * 10.05
	#instance.position = Vector3(spawnLocation.x/2, 0.0, spawnLocation.y/2) * 10.05
	instance.mesh.set_subdivide_width(tileSubdivision);#
	instance.mesh.set_subdivide_depth(tileSubdivision);
	instance.set_scale(Vector3(tileScale,1.0,tileScale))
	instance.name = "centerTile"
