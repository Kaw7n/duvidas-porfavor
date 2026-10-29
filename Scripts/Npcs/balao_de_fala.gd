extends Control

@onready var texto_label: Label = $NinePatchRect/MarginContainer/Label
@onready var anim_player: AnimationPlayer = $AnimationPlayer

#Vozes
@onready var voz_rodrigo: AudioStreamPlayer = $VozRodrigo
@onready var voz_pato_fred: AudioStreamPlayer = $VozPatoFred
@onready var voz_moema: AudioStreamPlayer = $VozMoema
@onready var voz_cct: AudioStreamPlayer = $VozCCT
@onready var voz_ccs: AudioStreamPlayer = $VozCCS
@onready var voz_ccg: AudioStreamPlayer = $VozCCG
@onready var voz_pensamento: AudioStreamPlayer = $VozPensamento

# Voz atual
var voz_atual: AudioStreamPlayer

var lista_falas: Array = []
var indice_atual: int = 0

signal dialogo_terminou

func _ready() -> void:
	#O balão inicia escondido, só esperando ser chamado com iniciar_dialogo()
	voz_atual = voz_rodrigo
	esconder_balao()

#Function publica: Qualquer personagem chama essa função passando seu ID do json (Exemplo: "moema", "professor", entre outros) onde está o chave_npc
func iniciar_dialogo(chave_npc: String, nome_voz: String = "VozRodrigo") -> void:
	if nome_voz != "" and has_node(nome_voz):
		voz_atual = get_node(nome_voz)
	else:
		voz_atual = voz_rodrigo
	
	lista_falas = GerenciadorDialogo.obter_falas(chave_npc)
	indice_atual = 0
	
	if lista_falas.size() > 0:
		exibir_frase_atual()
	else:
		push_error("Nenhuma fala encontrada para o NPC: " + chave_npc)
		esconder_balao()
		dialogo_terminou.emit()

# Atualiza o texto do balão e exibe o balão
func exibir_frase_atual() -> void:
	exibir_texto(lista_falas[indice_atual])

# Avança para a próxima frase do array
func avancar_dialogo() -> void:
	if typing:
		end_typing()
		return

	indice_atual += 1
	
	if indice_atual < lista_falas.size():
		exibir_frase_atual()
	else:
		esconder_balao()
		lista_falas = []
		indice_atual = 0
		dialogo_terminou.emit()

# Detecta o clique na UI do balão
func _gui_input(event: InputEvent) -> void:
	if visible and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		avancar_dialogo()

# Detecta atalhos globais do teclado (Enter, Espaço ou ui_accept)
func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_accept"):
		avancar_dialogo()

var text_speed = 30.0  
var typing = false
var visible_letters = 0.0

func exibir_texto(nova_frase: String) -> void:
	texto_label.text = nova_frase
	texto_label.visible_characters = 0
	visible_letters = 0.0
	typing = true
	mostrar_balao()
	
func _process(delta: float) -> void:
	if typing == false:
		return

	var begin = int(visible_letters)
	visible_letters += text_speed * delta
	var end = int(visible_letters)
	texto_label.visible_characters = int(visible_letters)

	if end > begin and end % 2 == 0:
		play_voice(end)
	
	if visible_letters >= texto_label.text.length():
		end_typing()
		
func end_typing() -> void:
	typing = false
	texto_label.visible_characters = -1

func mostrar_balao() -> void:
	visible = true
	if anim_player and anim_player.has_animation("flutuar"):
		anim_player.play("flutuar")

func esconder_balao() -> void:
	visible = false
	typing = false
	if anim_player:
		anim_player.stop()

#Dublagem

func play_voice(pos: int) -> void:
	var letter = texto_label.text.substr(pos - 1, 1).to_lower()

	if letter == " " or letter in [".", ",", "!", "?"]:
		return

	var new_beep: AudioStreamPlayer = voz_atual.duplicate()
	
	new_beep.pitch_scale += randf_range(-0.05, 0.05)
	
	if letter in ["a", "e", "i", "o", "u"]:
		new_beep.pitch_scale -= 0.1

	get_tree().root.add_child(new_beep)
	new_beep.play()
	await new_beep.finished
	new_beep.queue_free()
