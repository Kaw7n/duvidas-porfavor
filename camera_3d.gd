extends Camera3D

const sensibilidade := 0.0006

const FOV_MIN := 30.0
const FOV_MAX := 75.0 
const VELOCIDADE_ZOOM := 140.0 

var center_basis: Basis


func _ready():
	center_basis = global_basis
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
func _process(delta: float):
	if Input.is_key_pressed(KEY_Q):
		fov = move_toward(fov, FOV_MIN, VELOCIDADE_ZOOM * delta)
	else:
		fov = move_toward(fov, FOV_MAX, VELOCIDADE_ZOOM * delta)
		
	

func _input(event):
	if event is InputEventMouseMotion:
		var offset: Vector2 = -(get_viewport().get_mouse_position() - get_viewport().get_visible_rect().get_center()) * sensibilidade
		global_basis = center_basis
		rotate(Vector3.UP, offset.x)
		rotate(global_basis.x, offset.y)
