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
	
	# Ativa o tutorial
	Global.duvida_tutorial = true; 
	
	 # Espera o sinal pass_level.emit
	await Global.pass_level
	#Ativa a sequencia de animações -> sair
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	
	#Passa um level
	Global.level+=1 

func level_ccs():
	play("PlaceHolder-Npc2")
	Global.npcs_animations_sequence = ["npc_fade_in","npc_talk_2"]
	await play_seq()
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	Global.level+=1 

func level_ccg():
	play("PlaceHolder-Npc3")
	Global.npcs_animations_sequence = ["npc_fade_in","npc_talk_3"]
	await play_seq()
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	Global.level+=1 

func level_pato_fred():
	play("PlaceHolder-Npc4")
	Global.npcs_animations_sequence = ["npc_fade_in","npc_talk_1"]
	await play_seq()
	Global.npcs_animations_sequence = ["npc_fade_out"]
	await play_seq()
	Global.level+=1 

func level_cct():
	play("PlaceHolder-Npc5")
	Global.npcs_animations_sequence = ["npc_fade_in","npc_talk_2"]
	await play_seq()
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

func play_seq():
	Global.i = 0;
	await seq_end

func _on_click_npc(_collider):
	if npcs_animations.is_playing() or Global.i >= Global.npcs_animations_sequence.size():
		return #Proteger 
		
	npcs_animations.play(Global.npcs_animations_sequence[Global.i]);
	Global.i+= 1;
	
	if Global.i >= Global.npcs_animations_sequence.size():
		await npcs_animations.animation_finished
		seq_end.emit()
