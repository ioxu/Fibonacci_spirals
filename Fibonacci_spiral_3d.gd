extends MultiMeshInstance

var max_points = 400 setget set_max_points, get_max_points
export var point_scale = 0.75

var zerov = Vector3(0,0,0)
var ttransform = Transform()


func _ready():
	init_mmesh(get_max_points())


func init_mmesh(max_points):
	multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.color_format = MultiMesh.COLOR_FLOAT
	multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_NONE
	multimesh.instance_count = max_points
	multimesh.visible_instance_count = max_points

	var mesh : Mesh = load("res://unit_disk.obj")
	mesh.surface_set_material(0, load("res://unit_circle_ShaderMaterial.tres"))
	multimesh.set_mesh(mesh)


func init_mmesh_transforms():
	var b = Basis()
	for i in range(get_max_points()):
		b.x = zerov
		b.y = zerov
		b.z = zerov
		ttransform.basis = b
		multimesh.set_instance_transform(i, ttransform)


func update_spiral(n_points):
	var points = fibonacci_spiral_sphere( n_points )
	
	var scale = acos(n_points/(n_points+2)) * point_scale

	var b = Basis()
	var vy = Vector3(0,1,0)
	var vx = Vector3(1,0,0)
	
	for i in int(n_points):
		b.y = points[i].normalized() * scale
		b.x = - b.y.cross(vy).normalized() * scale
		b.z = - b.y.cross(b.x).normalized() * scale

		ttransform.basis = b
		ttransform.origin = points[i]

		# rainbow vertex albedo
		#var c = ( n_points-float(i) ) /n_points
		#multimesh.set_instance_color(i, Color.from_hsv(c+0.5, 1.0, 1.0 * c ) * 4 )

		ttransform = ttransform.rotated(vx, deg2rad(-90))
		multimesh.set_instance_transform(i, ttransform)

	if n_points < max_points:
		for i in range(int(n_points), max_points):
			b.x = zerov
			b.y = zerov
			b.z = zerov
			ttransform.basis = b
			multimesh.set_instance_transform(i, ttransform)


func set_max_points(npoints):
	print("set_max_points")
	multimesh.instance_count = npoints
	multimesh.visible_instance_count = npoints
	init_mmesh_transforms()


func get_max_points():
	return max_points


func fibonacci_spiral_sphere( npoints ):
	# npoints works as a float to smoothly interpolate the polar position
	# https://stackoverflow.com/questions/9600801/evenly-distributing-n-points-on-a-sphere
	# answer by https://stackoverflow.com/users/6731244/fab-von-bellingshausen
	var points = []
	var phi = PI * (3.0 - sqrt(5.0))
	for i in range(npoints):
		var y = 1 - (i / (npoints - 1.0)) *2
		var radius =  sqrt(1-y*y)
		var theta = phi * i
		var x = cos(theta) * radius
		var z = sin(theta) * radius
		points.append( Vector3(x,y,z) )
	return points
