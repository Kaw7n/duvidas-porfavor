extends AnimatedSprite3D

@export var camera_3d: Camera3D
@export var area_3d: Area3D
@export var npcs_animations: AnimationPlayer

# Funções das duvidas, cada uma, vou chamar de level pq 
# é mais bonitinho do que duvida

func _ready():
	camera_3d.click_npc.connect(_on_click_npc);
	seq_level()

func seq_level():
	while Global.level < 7:
		match Global.level:
			0:
				print('Fase Tutorial')
				await level_tutorial()
			1:
				print('Fase CCS')
				await level_ccs()
			2:
				print('Fase CCG')
				await level_ccg()
			3:
				print('Fase Pato Fred')
				await level_pato_fred()
			4: 
				print('Fase CCT')
				await level_cct()
			5: 
				print('Fase CCJ')
				await level_ccj()
			6:
				print('Fase Moema')
				if Global.lives >= 1:
					await level_moema() #
				else: 
					await level_game_over()
				print("Fim")

func level_tutorial():
	# Mudança de Sprite
	play("PlaceHolder-Npc1")
	
	# Ativa a Sequencia de Animações -> entrar -> falar
	Global.npcs_animations_sequence = ["npc_fade_in","npc_talk_1"]
	await play_seq()
	Global.duvida_tutorial = true; 
	# Ativa o tutorial
	
	 # Espera o sinal pass_level.emit
	await Global.pass_level
	#Ativa a sequencia de animações -> sair
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	
	#Passa um level
	Global.level = Global.level + 3 #Enquanto Não temos os CCS e CCG

func level_ccs(): # Desativado
	play("PlaceHolder-Npc2")
	Global.npcs_animations_sequence = ["npc_fade_in","npc_talk_2"]
	await play_seq()
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	Global.level+=1 

func level_ccg(): # Desativado
	play("PlaceHolder-Npc3")
	Global.npcs_animations_sequence = ["npc_fade_in","npc_talk_3"]
	await play_seq()
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	Global.level+=1 

func level_pato_fred():
	Global.npcs_animations_sequence = ["npc_fade_in"]
	await play_seq("PATOFRED-normal")
	Global.npcs_animations_sequence = ["npc_talk_1"]
	await play_seq("PATOFRED-talk")
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq("PATOFRED-happy")
	Global.level+=1 

func level_cct():
	Global.npcs_animations_sequence = ["npc_fade_in"]
	await play_seq("CCT-normal")
	Global.npcs_animations_sequence = ["npc_talk_2"]
	await play_seq("CCT-talk")
	
	Global.duvida_cct = true; 
	await Global.pass_level
	if Global.duvida_status == true:
		Global.npcs_animations_sequence = ["npc_talk_1"]
		await play_seq("CCT-happy")
	elif Global.duvidas_status == false:
		Global.npcs_animations_sequence = ["npc_talk_1"]
		await play_seq("CCT-normal")
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	Global.level+=1 
	
func level_ccj():
	play("PlaceHolder-Npc6")
	Global.npcs_animations_sequence = ["npc_fade_in","npc_talk_3"]
	await play_seq()
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	Global.level+=1 

func level_moema():
	play("PlaceHolder-Npc7")
	Global.npcs_animations_sequence = ["npc_fade_in","npc_talk_2"]
	await play_seq()
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	Global.level+=1 

func level_game_over():
	print("game over")

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
