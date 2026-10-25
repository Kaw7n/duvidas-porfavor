extends AnimatedSprite3D


@export var camera_3d: Camera3D
@export var area_3d: Area3D
@export var npcs_animations: AnimationPlayer
@export var balao_de_fala: Control
@export var balao_de_cutscene: Control
@export var animation_player: AnimationPlayer
@export var cutscene_being_2: Sprite2D
@export var cutscene_being_1: Sprite2D
@export var cutscene_good_ending: Sprite2D
@export var cutscene_bad_ending: Sprite2D
@export var camera_flash: AudioStreamPlayer
@export var game_over: AudioStreamPlayer
@export var computer_notification: AudioStreamPlayer
@export var moema_antiga: Sprite2D



# Funções das duvidas, cada uma, vou chamar de level pq 
# é mais bonitinho do que duvida

func _ready():
	moema_antiga.visible = false
	cutscene_being_2.visible = false
	cutscene_being_1.visible = false
	cutscene_good_ending.visible = false
	cutscene_bad_ending.visible = false
	camera_3d.click_npc.connect(_on_click_npc);
	await get_tree().process_frame
	seq_level()

func seq_level():
	while Global.level < 7:
		match Global.level:
			0:
				print("Cutscene Inicial")
				await cutscene_inicial()
			1:
				print('Fase Tutorial')
				await level_tutorial()
			2:
				print('Fase CCS')
				await level_ccs()
			3:
				print('Fase CCG')
				await level_ccg()
			4:
				print('Fase Pato Fred')
				await level_pato_fred()
			5: 
				print('Fase CCT')
				await level_cct()
			6:
				print('Fase Moema')
				if Global.lives >= 1:
					await level_moema() #
				else: 
					await level_game_over()
				

func talk(falas: String, sprite: String = "", voz: String = "VozRodrigo") -> void:
	if sprite != "":
		play(sprite)
	balao_de_fala.iniciar_dialogo(falas, voz)
	await balao_de_fala.dialogo_terminou
	
func think(falas: String, voz: String = "VozPensamento") -> void:
	balao_de_cutscene.iniciar_dialogo(falas, voz)
	await balao_de_cutscene.dialogo_terminou

func cutscene_inicial():
	moema_antiga.visible = true
	cutscene_being_2.visible = true
	cutscene_being_1.visible = true
	Global.click_switch = false;
	Global.move_switch = false;
	Global.zoom_switch = false;
	await get_tree().create_timer(1).timeout
	animation_player.play("cutscene_being_move_1")
	await think("cutscene_1")
	animation_player.play("cutscene_being_out_1")
	await animation_player.animation_finished
	animation_player.play("cutscene_being_move_2")
	await think("cutscene_2")
	animation_player.play("cutscene_being_blackout")
	await animation_player.animation_finished
	await think("cutscene_3")
	animation_player.play("moema_antiga_in")
	await animation_player.animation_finished
	await think("cutscene_4")
	animation_player.play("moema_antiga_out")
	await animation_player.animation_finished
	await think("cutscene_5")
	animation_player.play("cutscene_being_out_2")
	await animation_player.animation_finished
	Global.zoom_switch = true;
	Global.move_switch = true;
	cutscene_being_2.visible = false
	cutscene_being_1.visible = false
	moema_antiga.visible = false
	await think("cutscene_6")
	Global.click_switch = true;
	Global.level+=1 
		
func level_tutorial():
	# Mudança de Sprite
	play("RODRIGO-happy")
	
	# Ativa a Sequencia de Animações -> entrar -> falar
	Global.npcs_animations_sequence = ["npc_fade_in"]
	await play_seq()

	await talk("Rodrigo_falas_1", "RODRIGO-talk", "VozRodrigo")
	Global.npcs_animations_sequence = ["npc_talk_1"]
	play_seq()
	await talk("Rodrigo_falas_2", "RODRIGO-happy", "VozRodrigo")
	await talk("Rodrigo_falas_3", "RODRIGO-normal", "VozRodrigo")
	Global.npcs_animations_sequence = ["npc_talk_2"]
	play_seq()
	await talk("Rodrigo_falas_4", "RODRIGO-happy", "VozRodrigo")
	await talk("Rodrigo_falas_5", "RODRIGO-talk", "VozRodrigo")
	
	# Ativa o tutorial
	Global.duvida_tutorial = true

	 # Espera o sinal pass_level.emit
	await Global.pass_level
	#Ativa a sequencia de animações -> sair
	await talk("Rodrigo_falas_6", "RODRIGO-happy", "VozRodrigo")
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	
	#Passa um level
	Global.level+=1 

func level_ccs(): # Desativado
	play("CCS-normal")
	Global.npcs_animations_sequence = ["npc_fade_in"]
	await play_seq()

	await talk("aluno_ccs_falas_1", "CCS-talk", "VozCCS")
	Global.npcs_animations_sequence = ["npc_talk_1"]
	await play_seq()
	
	Global.duvida_ccs = true; 
	Global.signal_aluno_ccs.emit()
	await Global.pass_level;
	
	await get_tree().create_timer(2).timeout
	await talk("aluno_ccs_falas_2", "CCS-happy", "VozCCS")
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	Global.level+=1 

func level_ccg(): # Desativado
	play("CCG-normal")
	Global.npcs_animations_sequence = ["npc_fade_in"]
	await play_seq()

	await talk("aluno_ccg_falas_1", "CCG-talk", "VozCCG")
	Global.npcs_animations_sequence = ["npc_talk_1"]
	await play_seq()
	
	await talk("aluno_ccg_falas_2", "CCG-happy", "VozCCG")
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	Global.level+=1 

func level_pato_fred():
	play("PATOFRED-normal")
	Global.npcs_animations_sequence = ["npc_fade_in"]
	await play_seq()
	
	await talk("pato_fred_falas_1", "PATOFRED-happy", "VozPatoFred")
	Global.npcs_animations_sequence = ["npc_talk_2"]
	play_seq()
	await talk("pato_fred_falas_2", "PATOFRED-talk", "VozPatoFred")
	await talk("pato_fred_falas_3", "PATOFRED-normal", "VozPatoFred")
	Global.npcs_animations_sequence = ["npc_talk_3"]
	play_seq()
	await talk("pato_fred_falas_4", "PATOFRED-talk", "VozPatoFred")
	await talk("pato_fred_falas_5", "PATOFRED-normal", "VozPatoFred")
	
	Global.duvida_pato_fred = true; 
	Global.signal_pato_fred.emit()
	await Global.pass_level;
	
	if Global.duvida_status == true:
		Global.npcs_animations_sequence = ["npc_talk_1"]
		await play_seq("PATOFRED-happy")
		await talk("pato_fred_falas_6A", "PATOFRED-happy", "VozPatoFred")
	elif Global.duvida_status == false:
		Global.npcs_animations_sequence = ["npc_talk_1"]
		await play_seq("PATOFRED-normal")
		await talk("pato_fred_falas_6B", "PATOFRED-normal", "VozPatoFred")
		
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	Global.level+=1 

func level_cct():
	play("CCT-normal")
	Global.npcs_animations_sequence = ["npc_fade_in"]
	await play_seq()
	
	await talk("aluno_cct_falas_1", "CCT-talk", "VozCCT")
	Global.npcs_animations_sequence = ["npc_talk_1"]
	await play_seq()
	
	Global.duvida_cct = true; 
	await Global.pass_level
	
	if Global.duvida_status == true:
		Global.npcs_animations_sequence = ["npc_talk_1"]
		await play_seq("CCT-happy")
		await talk("aluno_cct_falas_3A", "CCT-happy", "VozCCT")
	elif Global.duvida_status == false:
		Global.npcs_animations_sequence = ["npc_talk_1"]
		await play_seq("CCT-normal")
		await talk("aluno_cct_falas_3B", "CCT-talk", "VozCCT")
		
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	Global.level+=1 

func level_moema():
		play("MOEMA-normal")
		Global.npcs_animations_sequence = ["npc_fade_in"]
		await play_seq()

		await talk("moema_falas_1", "MOEMA-talk", "VozMoema")
		Global.npcs_animations_sequence = ["npc_talk_1"]
		await play_seq()
	
		await talk("moema_falas_2", "MOEMA-happy", "VozMoema")
		cutscene_good_ending.visible = true 
		animation_player.play('good_ending')
		camera_flash.play()
		await animation_player.animation_finished
		Global.click_switch = false;
		Global.move_switch = false;
		Global.zoom_switch = false;
		await think('good_ending')
		Global.level += 1
	

func level_game_over():
	await get_tree().create_timer(2).timeout
	computer_notification.play()
	cutscene_bad_ending.visible = true 
	Global.dim_in.emit()
	await get_tree().create_timer(2).timeout
	animation_player.play('bad_ending')
	await animation_player.animation_finished
	game_over.play()
	Global.click_switch = false;
	Global.move_switch = false;
	Global.zoom_switch = false;
	await get_tree().create_timer(1).timeout
	await think('bad_ending')
	Global.level += 1
	
	

signal seq_end

var sprite_toggle := ""

func play_seq(sprite: String = ""):
	Global.i = 0
	sprite_toggle = sprite
	await seq_end

func _on_click_npc(_collider):
	if npcs_animations.is_playing() or Global.i >= Global.npcs_animations_sequence.size():
		return

	if sprite_toggle != "":
		play(sprite_toggle)
		sprite_toggle = ""

	npcs_animations.play(Global.npcs_animations_sequence[Global.i])
	Global.i += 1

	if Global.i >= Global.npcs_animations_sequence.size():
		await npcs_animations.animation_finished
		seq_end.emit()
