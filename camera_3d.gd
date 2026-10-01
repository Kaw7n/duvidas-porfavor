extends Camera3D

const sensibilidade := 0.0006

var center_basis: Basis


func _ready():
	center_basis = global_basis
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _input(event):
	if event is InputEventMouseMotion:
		var offset: Vector2 = -(get_viewport().get_mouse_position() - get_viewport().get_visible_rect().get_center()) * sensibilidade
		global_basis = center_basis
		rotate(Vector3.UP, offset.x)
		rotate(global_basis.x, offset.y)
