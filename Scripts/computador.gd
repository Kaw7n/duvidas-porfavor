extends Control

#Telas
@export var login: Sprite2D
@export var normal: Sprite2D
@export var loading: Sprite2D
@export var final: Sprite2D
@export var pc_melody: Sprite2D

@export var computer_animations: AnimationPlayer
@export var computador: Control
@export var password: LineEdit
@export var acess_buton: Button
@export var camera_3d: Camera3D
@export var area_click_computer: Area3D
@export var animation_player: AnimationPlayer



#audio
@export var click_sound: AudioStreamPlayer
@export var computer_melody: AudioStreamPlayer
@export var computer_on: AudioStreamPlayer
@export var incorret_passowrd: AudioStreamPlayer
@export var musica_orquestralde_vitoria_place_holder: AudioStreamPlayer


var click_sound_switch = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	computador.visible = false;
	login.visible = false;
	loading.visible = false;
	final.visible = false;
	pc_melody.visible = false; 
	normal.visible = true;
	
	camera_3d.click_computer.connect(_on_area_click_computer)

func switchComputer():
	if computador.visible == false:
		Global.dim_in.emit()
		animation_player.play('fade_in_computer')
		click_sound_switch = true;
		computador.visible = true;
		Global.click_switch = false;
		Global.move_switch = false;
		Global.zoom_switch = false;
		iniciar()
	elif computador.visible == true and Global.duvida_tutorial == false:
		
		Global.click_switch = true;
		Global.move_switch = true;
		Global.zoom_switch = true;
		click_sound_switch = false;
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
	
	computer_on.play()
	await computer_on.finished
	pc_melody.visible = true;
	login.visible = true;
	computer_animations.play('screen_turning_on');
	await computer_animations.animation_finished 
	computer_animations.play('pc_melody');
	normal.visible = false 
	computer_melody.play()
	await computer_melody.finished
	
	# Agora vai pra função - _on_acess_buton_pressed
	await correct_password
	
	await get_tree().create_timer(1).timeout
	login.visible = false;
	loading.visible = true;
	await get_tree().create_timer(2).timeout
	loading.visible = false;
	final.visible = true; 
	musica_orquestralde_vitoria_place_holder.play(); 
	Global.pass_level.emit()
	Global.duvida_tutorial = false; 
	
func duvida_cct():
	print('cct')

func _on_area_click_computer(_collider):
		switchComputer()
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") and computador.visible == true:
		switchComputer()
		return
		
	if event is InputEventMouseButton and event.pressed and click_sound_switch == true:
		click_sound.play()

signal correct_password

func _on_acess_buton_pressed() -> void:
	
	if password.text == 'munifor26':
		correct_password.emit()
	else:
		incorret_passowrd.play()
		password.clear()
		password.grab_focus()
