extends Node2D

@onready var label_status: Label = $Label 
@onready var timer_memorizacao: Timer = $TimerMemorizacao
@onready var musica_fundo: AudioStreamPlayer = $MusicaFundo
@onready var som_acerto: AudioStreamPlayer = $SomAcerto
@onready var som_erro: AudioStreamPlayer = $SomErro
@onready var som_derrota: AudioStreamPlayer = $SomDerrota

@export var animated_sprite_2d: AnimatedSprite2D
@export var silhueta_corpo: Sprite2D
@export var chapeu: Area2D
@export var coracao_falso: Area2D
@export var hamburguer: Area2D
@export var laco: Area2D
@export var olho: Area2D
@export var coracao_verdadeiro: Area2D
@export var pulmoes: Area2D
@export var tripas: Area2D
@export var animation_player: AnimationPlayer

var tempo_restante: int = 3
var fase_atual: int = 0 
var pontuacao: int = 0
var total_orgaos_certos: int = 4 
var orgaos_pontuados = []


var tempo_jogo: int = 30 
var jogo_ativo: bool = false
var timer_jogo: Timer

func _ready() -> void:
	Global.signal_aluno_ccs.connect(switchCCS)
	mudar_estado_pecas(false)
	conectar_sinal_pecas(self)

	if som_erro:
		som_erro.volume_db = -4.0
	if som_derrota:
		som_derrota.volume_db = -3.0

	timer_jogo = Timer.new()
	timer_jogo.wait_time = 1.0
	timer_jogo.one_shot = false
	timer_jogo.timeout.connect(_on_tempo_jogo_timeout)
	add_child(timer_jogo)

	if timer_memorizacao:
		timer_memorizacao.one_shot = false
		if not timer_memorizacao.timeout.is_connected(_on_timer_timeout):
			timer_memorizacao.timeout.connect(_on_timer_timeout)
			
	animated_sprite_2d.visible = false
	silhueta_corpo.visible = false
	chapeu.visible = false
	coracao_falso.visible = false
	hamburguer.visible = false
	laco.visible = false
	olho.visible = false
	coracao_verdadeiro.visible = false
	pulmoes.visible = false
	tripas.visible = false
	
	if label_status:
		label_status.text = ""
		label_status.visible = false

	if timer_memorizacao:
		timer_memorizacao.stop()
		
var changing = false;

func switchCCS():

	if changing == true:
		return
		
		# Ligar
	if Global.duvida_ccs == true: 
		changing = true;
		Global.dim_in.emit()
		
		Global.click_switch = false;
		Global.move_switch = false;
		Global.zoom_switch = false;
		
		animated_sprite_2d.visible = true
		silhueta_corpo.visible = true
		chapeu.visible = true
		coracao_falso.visible = true
		hamburguer.visible = true
		laco.visible = true
		olho.visible = true
		coracao_verdadeiro.visible = true
		pulmoes.visible = true
		tripas.visible = true
		
		animation_player.play('bubble_dim')
		await animation_player.animation_finished
		animation_player.play('corpse_in')
		await animation_player.animation_finished
		animation_player.play('organs_in')
		await animation_player.animation_finished
		changing = false
		
		tempo_restante = 3
		fase_atual = 0 
		pontuacao = 0
		total_orgaos_certos = 4 
		orgaos_pontuados = []
		tempo_jogo = 30 
		jogo_ativo = false
		
		being_ccs()
		
		# Desligar
	elif Global.duvida_ccs == false: 
		changing = true;
		
		animation_player.play('minigame_out')
		await animation_player.animation_finished
		
		animated_sprite_2d.visible = false
		silhueta_corpo.visible = false
		chapeu.visible = false
		coracao_falso.visible = false
		hamburguer.visible = false
		laco.visible = false
		olho.visible = false
		coracao_verdadeiro.visible = false
		pulmoes.visible = false
		tripas.visible = false

		Global.click_switch = true;
		Global.move_switch = true;
		Global.zoom_switch = true;
		
		if label_status:
			label_status.text = ""
			label_status.visible = false
		
		animation_player.play('music_fade_out')
		Global.dim_out.emit()
		await animation_player.animation_finished
		musica_fundo.stop()
		changing = false;

func being_ccs() -> void:
	if label_status:
		label_status.visible = true
		label_status.text = "ACERTE A POSIÇÃO DOS ÓRGÃOS!"

	if musica_fundo:
		musica_fundo.play()

	if timer_memorizacao:
		timer_memorizacao.wait_time = 2.5
		timer_memorizacao.start()

func _on_timer_timeout() -> void:
	if fase_atual == 0:
		fase_atual = 1
		if label_status:
			label_status.text = "NÃO CONFUNDA COM OS ÓRGÃOS FALSOS!"
		if timer_memorizacao:
			timer_memorizacao.wait_time = 2.5
			timer_memorizacao.start()
			
	elif fase_atual == 1:
		fase_atual = 2
		if timer_memorizacao:
			timer_memorizacao.wait_time = 1.0
			timer_memorizacao.start()
		executar_contagem()
		
	elif fase_atual == 2:
		if tempo_restante > 0:
			if label_status:
				label_status.text = str(tempo_restante)
			tempo_restante -= 1
		else:
			if timer_memorizacao:
				timer_memorizacao.stop()
				
			if label_status:
				label_status.text = "ORGANIZE!"
				
			mudar_estado_pecas(true)
			jogo_ativo = true
			timer_jogo.start()
			
			await get_tree().create_timer(1.0).timeout
			if label_status and pontuacao < total_orgaos_certos and jogo_ativo:
				label_status.text = "Tempo: " + str(tempo_jogo) + "s"


func executar_contagem() -> void:
	if label_status:
		label_status.text = str(tempo_restante)
	tempo_restante -= 1

func _on_tempo_jogo_timeout() -> void:
	if not jogo_ativo:
		return
		
	tempo_jogo -= 1
	if label_status and pontuacao < total_orgaos_certos:
		label_status.text = "Tempo: " + str(tempo_jogo) + "s"
		
	if tempo_jogo <= 0:
		jogo_ativo = false
		timer_jogo.stop()
		if label_status:
			label_status.text = "TEMPO ESGOTADO!"
		
		
		if musica_fundo:
			musica_fundo.stop()
			
		
		if som_derrota:
			som_derrota.play()
		mudar_estado_pecas(false)
		await get_tree().create_timer(6).timeout
		Global.duvida_ccs = false
		Global.duvida_status = false;
		Global.pass_level.emit()
		Global.lives -= 1
		switchCCS()
		


func conectar_sinal_pecas(no_atual: Node) -> void:
	if no_atual.has_signal("item_solto"):
		if not no_atual.is_connected("item_solto", _on_item_solto):
			no_atual.connect("item_solto", _on_item_solto)
			
	for filho in no_atual.get_children():
		conectar_sinal_pecas(filho)


func _on_item_solto(item_node: Node, posicao_solta: Vector2) -> void:
	if not jogo_ativo or item_node in orgaos_pontuados:
		return
		
	var acertou_algum = false
		
	for zona in get_tree().get_nodes_in_group("drop_zone"):
		if zona is Area2D:
			var nome_peca = item_node.name.to_lower()
			var nome_zona = zona.name.to_lower()
			
			var eh_o_orgao_certo = false
			if "olho" in nome_peca and "olho" in nome_zona:
				eh_o_orgao_certo = true
			elif "coracao" in nome_peca and "coracao" in nome_zona:
				eh_o_orgao_certo = true
			elif "pulmoes" in nome_peca and "pulmoes" in nome_zona:
				eh_o_orgao_certo = true
			elif "tripas" in nome_peca and "tripas" in nome_zona:
				eh_o_orgao_certo = true
				
			if eh_o_orgao_certo:
				var distancia = posicao_solta.distance_to(zona.global_position)
				
				if distancia <= 50.0:
					orgaos_pontuados.append(item_node)
					pontuacao += 1
					acertou_algum = true
					print("Ponto computado! Total: ", pontuacao)
					
					if som_acerto:
						som_acerto.play()
					
					if pontuacao >= total_orgaos_certos:
						jogo_ativo = false
						timer_jogo.stop()
						if label_status:
							label_status.text = "PARABÉNS! VOCÊ ACERTOU TUDO!"
						mudar_estado_pecas(false)
						await get_tree().create_timer(2).timeout
						Global.duvida_ccs = false
						Global.duvida_status = true;
						Global.pass_level.emit()
						switchCCS()
					break
					
	
	if not acertou_algum and jogo_ativo:
		if som_erro:
			som_erro.play()
			
		tempo_jogo -= 1 
		if label_status and pontuacao < total_orgaos_certos:
			label_status.text = "Tempo: " + str(tempo_jogo) + "s"
			
		
		if tempo_jogo <= 0:
			jogo_ativo = false
			timer_jogo.stop()
			if label_status:
				label_status.text = "TEMPO ESGOTADO! VOCÊ PERDEU..."
			if musica_fundo:
				musica_fundo.stop()
			if som_derrota:
				som_derrota.play()
			mudar_estado_pecas(false)


func mudar_estado_pecas(estado: bool) -> void:
	_aplicar_estado_recursivo(self, estado)


func _aplicar_estado_recursivo(no_atual: Node, estado: bool) -> void:
	if no_atual.has_method("liberar_movimento"):
		no_atual.liberar_movimento(estado)
	elif "pode_arrastar" in no_atual:
		no_atual.pode_arrastar = estado
		
	for filho in no_atual.get_children():
		_aplicar_estado_recursivo(filho, estado)
