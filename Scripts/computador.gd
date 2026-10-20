extends Control

#Telas
@export var login: Sprite2D
@export var normal: Sprite2D
@export var loading: Sprite2D
@export var final: Sprite2D
@export var pc_melody: Sprite2D
@export var cct_minigame: Sprite2D
@export var blackout: Sprite2D
@export var counter: AnimatedSprite2D


@export var computer_animations: AnimationPlayer
@export var computador: Control
@export var password: LineEdit
@export var access_button: Button
@export var camera_3d: Camera3D
@export var area_click_computer: Area3D
@export var animation_player: AnimationPlayer

#audio
@export var click_sound: AudioStreamPlayer
@export var computer_melody: AudioStreamPlayer
@export var computer_on: AudioStreamPlayer
@export var incorret_password: AudioStreamPlayer
@export var musica_orquestralde_vitoria_place_holder: AudioStreamPlayer
@export var cct_music: AudioStreamPlayer

#Minigames Moema
@export var true_moema_1: AnimatedSprite2D
@export var true_moema_2: AnimatedSprite2D
@export var true_moema_3: AnimatedSprite2D
@export var true_moema_4: AnimatedSprite2D
@export var true_moema_5: AnimatedSprite2D
@export var false_moema: AnimatedSprite2D
@export var moema_animations: AnimationPlayer
@export var timer_moema: Timer
@export var computer_codes: Sprite2D

@export var duvida_fail: AudioStreamPlayer
@export var duvida_win: AudioStreamPlayer
@export var moema_fail: AudioStreamPlayer
@export var moema_right: AudioStreamPlayer

@export var cct_fail: Sprite2D
@export var cct_win: Sprite2D

var click_sound_switch = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	computador.visible = false
	login.visible = false
	loading.visible = false
	final.visible = false
	pc_melody.visible = false
	normal.visible = true
	counter.visible = false
	cct_minigame.visible = false
	blackout.visible = false
	true_moema_1.visible = false
	true_moema_2.visible = false
	true_moema_3.visible = false
	true_moema_4.visible = false
	true_moema_5.visible = false
	false_moema.visible = false
	computer_codes.visible = false
	cct_win.visible = false
	cct_fail.visible = false
	
	camera_3d.click_computer.connect(_on_area_click_computer)
	
	
var changing = false; 
	
func switchComputer():
	
	if changing == true:
		return
		
	if computador.visible == false:
		changing = true;
		Global.dim_in.emit()
		animation_player.play('fade_in_computer')
		click_sound_switch = true;
		computador.visible = true;
		Global.click_switch = false;
		Global.move_switch = false;
		Global.zoom_switch = false;
		iniciar()
		changing = false;
	elif computador.visible == true and Global.duvida_tutorial == false and Global.duvida_cct == false:
		
		changing = true;
		Global.click_switch = true;
		Global.move_switch = true;
		Global.zoom_switch = true;
		click_sound_switch = false;
		Global.dim_out.emit()
		animation_player.play('fade_out_computer')
		await animation_player.animation_finished
		computador.visible = false;
		changing = false;

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
	
	# Agora vai pra função - _on_access_button_pressed
	await correct_password
	
	login.visible = false;
	loading.visible = true;
	await get_tree().create_timer(2).timeout
	loading.visible = false;
	final.visible = true; 
	duvida_win.play()
	Global.pass_level.emit()
	Global.duvida_tutorial = false; 
	
func duvida_cct():
	await get_tree().create_timer(1).timeout
	cct_music.play()
	cct_minigame.visible = true
	computer_animations.play('cct_minigame_in')
	blackout.visible = true
	counter.visible = true
	await cct_button 
	computer_animations.play('cct_minigame_out')
	await computer_animations.animation_finished 
	computer_animations.play('counter')
	await computer_animations.animation_finished 
	computer_codes.visible = true
	true_moema_1.visible = true
	true_moema_2.visible = true
	true_moema_3.visible = true
	true_moema_4.visible = true
	true_moema_5.visible = true
	false_moema.visible = true
	computer_animations.play('blackout_dim')
	moema_next_round()

signal cct_button 

func _on_area_click_computer(_collider):
		switchComputer()
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") and computador.visible == true:
		switchComputer()
		return
		
	if active_round and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if mouse_on_false_moema > 0:
			moema_falsa_hit()
		elif mouse_on_true_moema > 0:
			moema_verdadeira_hit()
		
	if event is InputEventMouseButton and event.pressed and click_sound_switch == true:
		click_sound.play()

signal correct_password

func _on_access_button_pressed() -> void:
	if password.text == 'munifor26':
		correct_password.emit()
	else:
		incorret_password.play()
		password.clear()
		password.grab_focus()

func _on_cct_begin_pressed() -> void:
	cct_button.emit()

# Mini game moema ///////////////////////////
var lifes = 3
var active_round = false
var round_moema = 1;
var mouse_on_false_moema = 0
var mouse_on_true_moema = 0

func being_round():
	active_round = true
	timer_moema.start()

func _on_timer_moema_timeout() -> void:
	if active_round:
		moema_verdadeira_hit()

func moema_falsa_hit():
	active_round = false
	timer_moema.stop()
	moema_right.play()
	round_moema +=1
	moema_next_round()

func moema_verdadeira_hit():
	active_round = false
	timer_moema.stop()
	moema_fail.play()
	lifes -= 1
	round_moema +=1
	moema_next_round()

func moema_next_round():
	match round_moema:
			1:
				moema_animations.play('round1')
				await moema_animations.animation_finished 
				being_round()
			2:
				moema_animations.play('round2')
				await moema_animations.animation_finished
				being_round() 
			3:
				moema_animations.play('round3')
				await moema_animations.animation_finished 
				being_round()
			4:
				moema_animations.play('round4')
				await moema_animations.animation_finished 
				being_round()
			5:
				game_over()

func game_over():
	cct_music.stop()
	Global.pass_level.emit()
	Global.duvida_cct = false; 
	#caso seja derrota
	if lifes <= 0:
		cct_fail.visible = true
		duvida_fail.play()
		Global.duvida_status = false
	else:
		cct_win.visible = true
		duvida_win.play()
		Global.duvida_status = true
	
	final.visible = false 
	true_moema_1.visible = false
	true_moema_2.visible = false
	true_moema_3.visible = false
	true_moema_4.visible = false
	true_moema_5.visible = false
	false_moema.visible = false
	computer_codes.visible = false
	
func _on_win_mouse_entered() -> void: #Entrou na colisão da Moema Falsa
	mouse_on_false_moema += 1

func _on_win_mouse_exited() -> void: #Saiu da colisão da Moema Falsa
	mouse_on_false_moema = max(0, mouse_on_false_moema - 1)

func _on_fail_mouse_entered() -> void:
	mouse_on_true_moema +=1
	
func _on_fail_mouse_exited() -> void:
	mouse_on_true_moema = max(0, mouse_on_true_moema - 1)
