extends Camera3D

const FOV_MIN := 30.0
const FOV_MAX := 75.0 
const VELOCIDADE_ZOOM := 140.0 

var center_basis: Basis

func _ready():
	center_basis = global_basis
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
func _process(delta: float):
	if Global.zoom_switch == false:   
		return
	if Input.is_key_pressed(KEY_Q):
		fov = move_toward(fov, FOV_MIN, VELOCIDADE_ZOOM * delta)
	else:
		fov = move_toward(fov, FOV_MAX, VELOCIDADE_ZOOM * delta)
		
	
func _input(event):
	#camera
	
	if event is InputEventMouseMotion and Global.move_switch == true:
		var offset: Vector2 = -(get_viewport().get_mouse_position() - get_viewport().get_visible_rect().get_center()) * Global.sens
		global_basis = center_basis
		rotate(Vector3.UP, offset.x)
		rotate(global_basis.x, offset.y)
	#clique
	if event.is_action_pressed("click") and Global.click_switch == true:
		point_click();

signal click_npc(collider);

func point_click():
	# Sistema de Point and Click
	var mouse_pos = get_viewport().get_mouse_position()
	var alcance = 1000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * alcance
	var space = get_world_3d().direct_space_state
	# Verifica Se acertou algo
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	var raycast_result = space.intersect_ray(ray_query)

	# Emitindo o sinal para o npc
	if raycast_result:
		click_npc.emit(raycast_result.collider)
