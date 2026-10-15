extends Control

#Telas
@export var login: Sprite2D
@export var normal: Sprite2D
@export var loading: Sprite2D
@export var final: Sprite2D

@export var computador: Control
@export var inserir_senha: LineEdit
@export var acess_buton: Button
@export var camera_3d: Camera3D
@export var area_click_computer: Area3D
@export var animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	computador.visible = false;
	login.visible = false;
	loading.visible = false;
	final.visible = false;
	normal.visible = true;
	camera_3d.click_computer.connect(_on_area_click_computer)

func switchComputer():
	if computador.visible == false:
		Global.dim_in.emit()
		animation_player.play('fade_in_computer')
		computador.visible = true;
		Global.click_switch = false;
		Global.move_switch = false;
		Global.zoom_switch = false;
		iniciar()
	else:
		Global.click_switch = true;
		Global.move_switch = true;
		Global.zoom_switch = true;
		Global.dim_out.emit()
		animation_player.play('fade_out_computer')
		await animation_player.animation_finished
		computador.visible = false;

func _on_exit_config_pressed() -> void:
	switchComputer();

func iniciar():
	if Global.duvida_tutorial == true:
		tutorial()
	if Global.duvida_cct == true:
		duvida_cct()
	
func tutorial():
	print('tutorial')
	
func duvida_cct():
	print('cct')

func _on_area_click_computer(_collider):
		switchComputer()
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") and computador.visible == true:
		switchComputer()
