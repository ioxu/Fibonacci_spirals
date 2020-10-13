extends ImmediateGeometry
tool


export(bool) var faded_axes = false
export(bool) var poles_axes = true

var axes_size = 3

export(float) var poles_brightness = 1.5

var point_set = [Vector3(-1, 0, 0), Vector3(1,0,0),
	Vector3(0,-1,0), Vector3(0,1,0),
	Vector3(0,0,-1), Vector3(0,0,1)]

export var x_col : Color = Color(1,0,0,1)
var x_col_t = x_col * Color(1,1,1,0) #Color(1,0,0,0)
export var y_col : Color = Color(0,1,0,1)
var y_col_t = y_col * Color(1,1,1,0) #Color(0,1,0,0)
export var z_col : Color = Color(0,0,1,1)
var z_col_t = z_col * Color(1,1,1,0) #Color(0,0,1,0)

export var poles_col : Color = Color(0.0,0.0,1,1).to_rgba32()

func _process(_delta):
	clear()

	if poles_axes:
		begin(Mesh.PRIMITIVE_LINES, null)
		set_color(poles_col * poles_brightness)
		add_vertex(Vector3(0,0,1.02))
		add_vertex(Vector3(0,0,1.1))
		add_vertex(Vector3(0,0,-1.02))
		add_vertex(Vector3(0,0,-1.1))
		end()

	if faded_axes:
		#x 
		begin(Mesh.PRIMITIVE_LINE_STRIP, null)
		set_color(x_col_t)
		add_vertex(point_set[0]*axes_size)
		set_color(x_col)
		add_vertex(Vector3(0,0,0))
		set_color(x_col_t)
		add_vertex(point_set[1]*axes_size)
		end()
	
		#y 
		begin(Mesh.PRIMITIVE_LINE_STRIP, null)
		set_color(y_col_t)
		add_vertex(point_set[2]*axes_size)
		set_color(y_col)
		add_vertex(Vector3(0,0,0))
		set_color(y_col_t)
		add_vertex(point_set[3]*axes_size)
		end()
	
		#z 
		begin(Mesh.PRIMITIVE_LINE_STRIP, null)
		set_color(z_col_t)
		add_vertex(point_set[4]*axes_size)
		set_color(z_col)
		add_vertex(Vector3(0,0,0))
		set_color(z_col_t)
		add_vertex(point_set[5]*axes_size)
		end()

