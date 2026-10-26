extends Node2D

# Lista com todas as 6 questões da prova
@onready var lista_questoes = [
	$questao1,
	$questao2,
	$questao3,
	$questao4,
	$questao5,
	$questao6
]

# Referência para a tela de resultado
@onready var node_resultado: Node2D = $resultado

# Referências para os nós de áudio
@onready var som_virar: AudioStreamPlayer = $SomVirarPagina
@onready var musica_fundo: AudioStreamPlayer = $MusicaFundo
@onready var som_vitoria: AudioStreamPlayer = $SomVitoria
@onready var som_derrota: AudioStreamPlayer = $SomDerrota

# Caminhos dos sprites da folha de prova
@onready var textura_normal = preload("res://Assets 2D/MinigameCCG/papel1.png")
@onready var textura_dobrada = preload("res://Assets 2D/MinigameCCG/papel_dobrado.png")

# Gabarito: comportamento real do aluno em cada questão
var gabarito_aluno_acertou = [
	true,  # Questão 1
	false, # Questão 2
	false, # Questão 3
	true,  # Questão 4
	false, # Questão 5
	true   # Questão 6
]

var indice_atual: int = 0
var acertos_jogador: int = 0
var respondido_nesta_questao: bool = false


func _ready() -> void:
	iniciar_minigame()


func iniciar_minigame() -> void:
	indice_atual = 0
	acertos_jogador = 0

	if node_resultado:
		node_resultado.visible = false

	# Inicia a música de fundo
	if musica_fundo and not musica_fundo.playing:
		musica_fundo.play()

	atualizar_visibilidade_questoes()
	conectar_botoes_atuais()


func atualizar_visibilidade_questoes() -> void:
	for i in range(lista_questoes.size()):
		if lista_questoes[i] != null:
			lista_questoes[i].visible = (i == indice_atual)

	var q_atual = lista_questoes[indice_atual]

	if q_atual:
		if q_atual is Sprite2D:
			q_atual.texture = textura_normal

		if q_atual.has_node("avancar"):
			q_atual.get_node("avancar").visible = false

		if q_atual.has_node("certo"):
			q_atual.get_node("certo").visible = true

		if q_atual.has_node("errado"):
			q_atual.get_node("errado").visible = true

		if q_atual.has_node("certo2"):
			q_atual.get_node("certo2").visible = true

		if q_atual.has_node("errado2"):
			q_atual.get_node("errado2").visible = true

		if q_atual.has_node("Correcao"):
			q_atual.get_node("Correcao").visible = true

	respondido_nesta_questao = false


func conectar_botoes_atuais() -> void:
	var q_atual = lista_questoes[indice_atual]

	if not q_atual:
		return

	if q_atual.has_node("certo"):
		var btn_certo = q_atual.get_node("certo")

		if not btn_certo.pressed.is_connected(_on_botao_certo_pressed):
			btn_certo.pressed.connect(_on_botao_certo_pressed)

	if q_atual.has_node("errado"):
		var btn_errado = q_atual.get_node("errado")

		if not btn_errado.pressed.is_connected(_on_botao_errado_pressed):
			btn_errado.pressed.connect(_on_botao_errado_pressed)

	if q_atual.has_node("avancar"):
		var btn_avancar = q_atual.get_node("avancar")

		if not btn_avancar.pressed.is_connected(_on_botao_avancar_pressed):
			btn_avancar.pressed.connect(_on_botao_avancar_pressed)


func _on_botao_certo_pressed() -> void:
	processar_resposta(true)


func _on_botao_errado_pressed() -> void:
	processar_resposta(false)


func processar_resposta(jogador_disse_que_acertou: bool) -> void:
	if respondido_nesta_questao:
		return

	respondido_nesta_questao = true

	var aluno_realmente_acertou = gabarito_aluno_acertou[indice_atual]

	if jogador_disse_que_acertou == aluno_realmente_acertou:
		acertos_jogador += 1
		print("Boa! Correção certa. Pontos: ", acertos_jogador)
	else:
		print("Ops! Correção errada.")

	var q_atual = lista_questoes[indice_atual]

	if q_atual:
		if q_atual is Sprite2D:
			q_atual.texture = textura_dobrada

		if q_atual.has_node("certo"):
			q_atual.get_node("certo").visible = false

		if q_atual.has_node("errado"):
			q_atual.get_node("errado").visible = false

		if q_atual.has_node("certo2"):
			q_atual.get_node("certo2").visible = false

		if q_atual.has_node("errado2"):
			q_atual.get_node("errado2").visible = false

		if q_atual.has_node("Correcao"):
			q_atual.get_node("Correcao").visible = false

		if q_atual.has_node("avancar"):
			q_atual.get_node("avancar").visible = true


func _on_botao_avancar_pressed() -> void:
	if not respondido_nesta_questao:
		return

	if som_virar:
		som_virar.play()

	indice_atual += 1

	if indice_atual < lista_questoes.size():
		atualizar_visibilidade_questoes()
		conectar_botoes_atuais()
	else:
		mostrar_resultado_final()


func mostrar_resultado_final() -> void:
	if musica_fundo:
		musica_fundo.stop()

	if som_virar:
		som_virar.stop()

	for q in lista_questoes:
		if q:
			q.visible = false

	if not node_resultado:
		return

	node_resultado.visible = true

	if node_resultado.has_node("aviso"):
		node_resultado.get_node("aviso").text = "Calculando correção..."

	if node_resultado.has_node("acertos"):
		node_resultado.get_node("acertos").text = ""

	if node_resultado.has_node("resultadoFinal"):
		node_resultado.get_node("resultadoFinal").text = ""

	await get_tree().create_timer(3.0).timeout

	var total = lista_questoes.size()

	if node_resultado.has_node("aviso"):
		node_resultado.get_node("aviso").text = "Monitor, sua correção está..."

	# Exibe explicitamente a palavra Acertos com o total obtido
	if node_resultado.has_node("acertos"):
		node_resultado.get_node("acertos").text = "Acertos: " + str(acertos_jogador) + " de " + str(total)

	if node_resultado.has_node("resultadoFinal"):
		if acertos_jogador >= 3:
			node_resultado.get_node("resultadoFinal").text = "Parabéns! Você passou no teste da correção!"
			if som_vitoria:
				som_vitoria.play()
		else:
			node_resultado.get_node("resultadoFinal").text = "Reprovado! Tente novamente."
			if som_derrota:
				som_derrota.play()
