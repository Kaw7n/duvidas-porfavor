extends Camera3D

const FOV_MIN := 30.0
const FOV_MAX := 75.0 
const VELOCIDADE_ZOOM := 140.0 
const smooth = 6;

var center_basis: Basis
var camera_offset := Vector2(0,0)
var end_offset := Vector2(0,0)

func _ready():
	center_basis = global_basis
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
func _process(delta: float):
	# suavização
	if Global.move_switch:
		var x := 1.0 - exp(-smooth * delta)
		camera_offset = camera_offset.lerp(end_offset, x)
		global_basis = center_basis
		rotate(Vector3.UP, camera_offset.x)
		rotate(global_basis.x, camera_offset.y)
		
	if Global.zoom_switch == false:   
		return
	if Input.is_key_pressed(KEY_Q):
		fov = move_toward(fov, FOV_MIN, VELOCIDADE_ZOOM * delta)
	else:
		fov = move_toward(fov, FOV_MAX, VELOCIDADE_ZOOM * delta)
		
	
func _input(event):
	#camera
	if event is InputEventMouseMotion and Global.move_switch == true:
		end_offset = -(get_viewport().get_mouse_position() - get_viewport().get_visible_rect().get_center()) * Global.sens
	#clique
	if event.is_action_pressed("click") and Global.click_switch == true:
		point_click()

signal click_npc(collider);
signal click_computer(collider);

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

	# Emitindo o sinal para o npc ou para o computador
	
	if raycast_result.is_empty():
		return
	var collider = raycast_result.collider
	if collider.is_in_group("computer"):
		click_computer.emit(collider)
	elif collider.is_in_group("npc"):
		click_npc.emit(collider)
			
