extends Area2D

var pode_arrastar: bool = false
var sendo_arrastado: bool = false
var offset_mouse: Vector2 = Vector2.ZERO

signal item_solto(item_node, posicao_solta)

func _ready() -> void:
	input_pickable = true

func _process(_delta: float) -> void:
	if sendo_arrastado:
		global_position = get_global_mouse_position() - offset_mouse

func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not pode_arrastar:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			sendo_arrastado = true
			offset_mouse = get_global_mouse_position() - global_position
			z_index = 10
		else:
			if sendo_arrastado:
				sendo_arrastado = false
				z_index = 0
				emit_signal("item_solto", self, global_position)

func liberar_movimento(estado: bool) -> void:
	pode_arrastar = estado

# Nova função para fixar o órgão perfeitamente na DropZone sem distorcer
func encaixar_na_posicao(posicao_alvo: Vector2) -> void:
	global_position = posicao_alvo
	pode_arrastar = false
	sendo_arrastado = false
	z_index = 0
