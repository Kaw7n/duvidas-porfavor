extends Node

var dados_dialogo: Dictionary = {}

func _ready() -> void:
	carregar_dialogos("res://Scripts/Npcs/dialogos.json")

func carregar_dialogos(caminho: String) -> void:
	if not FileAccess.file_exists(caminho):
		push_error("Arquivo não encontrado em: " + caminho)
		return

	var arquivo = FileAccess.open(caminho, FileAccess.READ)
	var conteudo = arquivo.get_as_text()
	arquivo.close()

	var json = JSON.new()
	if json.parse(conteudo) == OK:
		dados_dialogo = json.data
		print("SUCESSO: Diálogos carregados no gerenciador!")
	else:
		push_error("Erro de formatação no JSON")

func obter_falas(chave_npc: String) -> Array:
	if dados_dialogo.has(chave_npc) and dados_dialogo[chave_npc].has("falas"):
		return dados_dialogo[chave_npc]["falas"]
	return []
