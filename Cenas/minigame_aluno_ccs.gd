extends Node2D

@onready var label_status: Label = $Label 
@onready var timer_memorizacao: Timer = $TimerMemorizacao
@onready var musica_fundo: AudioStreamPlayer = $MusicaFundo
@onready var som_acerto: AudioStreamPlayer = $SomAcerto
@onready var som_erro: AudioStreamPlayer = $SomErro
@onready var som_derrota: AudioStreamPlayer = $SomDerrota

var tempo_restante: int = 3
var fase_atual: int = 0 
var pontuacao: int = 0
var total_orgaos_certos: int = 4 
var orgaos_pontuados = []


var tempo_jogo: int = 30 
var jogo_ativo: bool = false
var timer_jogo: Timer

func _ready() -> void:
	mudar_estado_pecas(false)
	conectar_sinal_pecas(self)
	
	
	if som_erro:
		som_erro.volume_db = -4.0 
	if som_derrota:
		som_derrota.volume_db = -3.0 
	
	
	if musica_fundo:
		musica_fundo.play()
	
	
	timer_jogo = Timer.new()
	timer_jogo.wait_time = 1.0
	timer_jogo.one_shot = false
	timer_jogo.timeout.connect(_on_tempo_jogo_timeout)
	add_child(timer_jogo)
	
	if label_status:
		label_status.text = "ACERTE A POSIÇÃO DOS ÓRGÃOS!"
	
	if timer_memorizacao:
		timer_memorizacao.wait_time = 2.5
		timer_memorizacao.one_shot = false
		if not timer_memorizacao.timeout.is_connected(_on_timer_timeout):
			timer_memorizacao.timeout.connect(_on_timer_timeout)
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
			label_status.text = "TEMPO ESGOTADO! TENTE NOVAMENTE"
		
		
		if musica_fundo:
			musica_fundo.stop()
			
		
		if som_derrota:
			som_derrota.play()
			
		mudar_estado_pecas(false)


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
