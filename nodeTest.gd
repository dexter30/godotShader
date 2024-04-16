extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_tabel(10) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func generate_tabel(grid_size):
	var center = (grid_size - 1)/2
	var subdivision_max = center *3
	print ("Array Index \tSpawn Point (Vector2)\tSubdivision (Int)\tScale (Int)\t distance ")
	
	for y in range(grid_size):
		for x in range(grid_size):
			var spawnPoint = Vector2(x - center, y - center)
			var distance  =spawnPoint.distance_to(Vector2(0,0))
			var subdivision = subdivision_max - distance *33
			
			var scale = 3
			if distance > 3:
				scale = 1
			
			
			print ("%d\t\t%s\t\t%d\t\t%d\t\t%d" % [y * grid_size + x, spawnPoint, subdivision, scale,distance])
			
