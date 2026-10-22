extends Control

@export var animation_player: AnimationPlayer

@export var area_2d_ok_path: Area2D
@export var area_2d_blocked_path_1: Area2D
@export var area_2d_blocked_path_2: Area2D
@export var mouse_begin: Marker2D
@export var pato_fred_cursor: CompressedTexture2D
@export var area_2d_exit: Area2D
@export var area_2d_white_duck: Area2D
@export var area_2d_red_duck: Area2D
@export var area_2d_yellow_duck: Area2D
@export var area_2d_green_duck: Area2D

@export var quack: AudioStreamPlayer
@export var ducks_fail: AudioStreamPlayer
@export var duvida_win: AudioStreamPlayer
@export var duvida_fail: AudioStreamPlayer
@export var ducks_fall: AudioStreamPlayer
@export var patofred_music: AudioStreamPlayer


# assets
@export var animated_sprite_2d: AnimatedSprite2D
@export var mapa: Sprite2D
@export var caminho: Sprite2D
@export var blocos: Sprite2D
@export var white_duck: Sprite2D
@export var red_duck: Sprite2D
@export var yellow_duck: Sprite2D
@export var green_duck: Sprite2D
@export var minigame_pato_fred: Control

var maze = false
var maze_fail = false  
var ducks = 4;
var maze_lifes = 3;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.signal_pato_fred.connect(switchComputer)
	
	minigame_pato_fred.visible = false
	animated_sprite_2d.visible = false
	mapa.visible = false
	caminho.visible = false
	blocos.visible = false
	white_duck.visible = false
	red_duck.visible = false
	yellow_duck.visible = false
	green_duck.visible = false

var changing = false; 
	
func switchComputer():
	
	if changing == true:
		return
		# Ligar
	if Global.duvida_pato_fred == true: #computador.visible == false:
		changing = true;
		Global.dim_in.emit()
		
		Global.click_switch = false;
		Global.move_switch = false;
		Global.zoom_switch = false;
		
		minigame_pato_fred.visible = true
		animated_sprite_2d.visible = true
		mapa.visible = true
		caminho.visible = true
		blocos.visible = true
		white_duck.visible = true
		red_duck.visible = true
		yellow_duck.visible = true
		green_duck.visible = true
		animation_player.play('bubble_dim')
		await animation_player.animation_finished
		animation_player.play('map_dim')
		patofred_music.play()
		await animation_player.animation_finished
		animation_player.play('ducks')
		ducks_fall.play()
		await animation_player.animation_finished
		animation_player.play('ducks_dance')
		changing = false;
		maze_start()
		
		# Desligar
	elif Global.duvida_pato_fred == false: #true and Global.duvida_tutorial == false and Global.duvida_cct == false:
		changing = true;
		
		maze = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Input.set_custom_mouse_cursor(null)
		
		animation_player.play('end_dim_out')
		await animation_player.animation_finished

		Global.click_switch = true;
		Global.move_switch = true;
		Global.zoom_switch = true;
		
		animated_sprite_2d.visible = false
		mapa.visible = false
		caminho.visible = false
		blocos.visible = false
		white_duck.visible = false
		red_duck.visible = false
		yellow_duck.visible = false
		green_duck.visible = false
		minigame_pato_fred.visible = false
		animation_player.play('fade_out_music')
		Global.dim_out.emit()
		await animation_player.animation_finished
		patofred_music.stop()
		changing = false;

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_T:
		teleport_mouse()

func maze_start():
	Input.set_custom_mouse_cursor(pato_fred_cursor, Input.CURSOR_ARROW, Vector2(16, 31))
	teleport_mouse()
	maze = true;
	
func maze_reset():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if maze_lifes <= 0:
		duvida_fail.play()
		Global.duvida_pato_fred = false
		Global.duvida_status = false;
		Global.pass_level.emit()
		switchComputer()
	else:
		teleport_mouse()
		maze_fail = false
		maze = true;
		
func teleport_mouse(): #teleporta o mouse
	var i := mouse_begin.get_global_transform_with_canvas().origin
	Input.warp_mouse(i)

func fail():
	if maze_fail == true:
		return
	maze_fail = true
	maze = false
	maze_lifes -= 1
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ducks_fail.play()
	await get_tree().create_timer(0.3).timeout
	maze_reset()

func _on_area_2d_ok_path_mouse_entered() -> void:
	pass

func _on_area_2d_ok_path_mouse_exited() -> void:
	print("saiu do caminho")
	if maze == true:
			fail()
	
func _on_area_2d_blocked_path_mouse_entered() -> void:
	print("entrou na area proibida")
	if maze == true:
			fail()

# Patos
func _on_area_2d_white_duck_mouse_entered() -> void:
	if maze == true and white_duck.visible == true:
		quack.play()
		white_duck.visible = false
		ducks -= 1
		
func _on_area_2d_red_duck_mouse_entered() -> void:
	if maze == true and red_duck.visible == true:
		quack.play()
		red_duck.visible = false
		ducks -= 1

func _on_area_2d_yellow_duck_mouse_entered() -> void:
	if maze == true and yellow_duck.visible == true:
		quack.play()
		yellow_duck.visible = false
		ducks -= 1

func _on_area_2d_green_duck_mouse_entered() -> void:
	if maze == true and green_duck.visible == true:
		quack.play()
		green_duck.visible = false
		ducks -= 1
		
func _on_area_2d_exit_mouse_entered() -> void:
	if maze == true:
		if ducks == 0:
			maze = false
			duvida_win.play()
			Global.duvida_pato_fred = false
			Global.duvida_status = true;
			Global.pass_level.emit()
			switchComputer()
		else:
			ducks_fail.play()
