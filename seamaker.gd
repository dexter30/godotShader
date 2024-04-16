@tool
extends EditorScript

var nuNode = null

var OceanTile = preload("res://seas.tscn");
var spawnPoint = preload("res://data/GridSpawnInfo.tres")


func createT(grid_size):
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
				
				get_scene().add_child(instance)
				instance.owner = get_scene()
				
				instance.position = Vector3(spawnLocation.x,0.0,spawnLocation.y) * 10.05
				instance.mesh.set_subdivide_width(tileSubdivision);#
				instance.mesh.set_subdivide_depth(tileSubdivision);
				instance.set_scale(Vector3(tileScale,1.0,tileScale))
			if i == 1  or i == grid_size -2 or j ==1 or j == grid_size - 2:
				var spawnLocation = Vector2(i - center, j - center)#spawnPoint.spawnPoints[i]
				var tileSubdivision = 99#spawnPoint.subdivision[i]
				var tileScale  = 1#spawnPoint.scale[i]
				var instance = OceanTile.instantiate()
				
				get_scene().add_child(instance)
				instance.owner = get_scene()
				
				instance.position = Vector3(spawnLocation.x,0.0,spawnLocation.y) * 10.05
				instance.mesh.set_subdivide_width(tileSubdivision);#
				instance.mesh.set_subdivide_depth(tileSubdivision);
				instance.set_scale(Vector3(tileScale,1.0,tileScale))
	
	var spawnLocation = Vector2(0, 0)#spawnPoint.spawnPoints[i]
	var tileSubdivision = 199#spawnPoint.subdivision[i]
	var tileScale  = grid_size-4#spawnPoint.scale[i]
	var instance = OceanTile.instantiate()
	
	get_scene().add_child(instance)
	instance.owner = get_scene()
	
	instance.position = Vector3(spawnLocation.x+ 10.05/2, 0.0, spawnLocation.y+ 10.05/2)# * 10.05
	#instance.position = Vector3(spawnLocation.x/2, 0.0, spawnLocation.y/2) * 10.05
	instance.mesh.set_subdivide_width(tileSubdivision);#
	instance.mesh.set_subdivide_depth(tileSubdivision);
	instance.set_scale(Vector3(tileScale,1.0,tileScale))
	
func _run():
	# `parent` could be any node in the scene.
	#var parent = get_scene()
	#var node = Node3D.new()
	#parent.add_child(node)
	createT(10)
	# The line below is required to make the node visible in the Scene tree dock
	# and persist changes made by the tool script to the saved scene file.
	#node.owner = get_scene()
