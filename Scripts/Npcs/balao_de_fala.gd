extends Control

@onready var texto_label: Label = $NinePatchRect/MarginContainer/Label
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var lista_falas: Array = []
var indice_atual: int = 0

func _ready() -> void:
	#O balão inicia escondido, só esperando ser chamado com iniciar_dialogo()
	esconder_balao()

#Function publica: Qualquer personagem chama essa função passando seu ID do json (Exemplo: "moema", "professor", entre outros) onde está o chave_npc
func iniciar_dialogo(chave_npc: String) -> void:
	lista_falas = GerenciadorDialogo.obter_falas(chave_npc)
	indice_atual = 0
	
	if lista_falas.size() > 0:
		exibir_frase_atual()
	else:
		push_error("Nenhuma fala encontrada para o NPC: " + chave_npc)
		esconder_balao()

# Atualiza o texto do balão e exibe o balão
func exibir_frase_atual() -> void:
	exibir_texto(lista_falas[indice_atual])

# Avança para a próxima frase do array
func avancar_dialogo() -> void:
	indice_atual += 1
	
	if indice_atual < lista_falas.size():
		exibir_frase_atual()
	else:
		esconder_balao()
		lista_falas.clear()
		indice_atual = 0

# Detecta o clique na UI do balão
func _gui_input(event: InputEvent) -> void:
	if visible and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		avancar_dialogo()

# Detecta atalhos globais do teclado (Enter, Espaço ou ui_accept)
func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_accept"):
		avancar_dialogo()

func exibir_texto(nova_frase: String) -> void:
	if texto_label:
		texto_label.text = nova_frase
	mostrar_balao()

func mostrar_balao() -> void:
	visible = true
	if anim_player and anim_player.has_animation("flutuar"):
		anim_player.play("flutuar")

func esconder_balao() -> void:
	visible = false
	if anim_player:
		anim_player.stop()
