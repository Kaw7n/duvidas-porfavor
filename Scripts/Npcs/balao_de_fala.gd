extends Control

@onready var texto_label: Label = $NinePatchRect/MarginContainer/Label
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if anim_player and anim_player.has_animation("flutuar"):
		anim_player.play("flutuar")

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
