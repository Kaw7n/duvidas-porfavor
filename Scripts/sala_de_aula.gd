extends Node3D

@export var credits: Control
@export var animation_player: AnimationPlayer
@export var som_virar_pagina: AudioStreamPlayer
@export var main_bmg: AudioStreamPlayer

func _ready() -> void:
	Global.the_end.connect(the_end);
	$Fade/AnimationPlayer.play("fade_out");
	credits.visible = false
	
func the_end():
	$Fade/AnimationPlayer.play("fade_in");
	await get_tree().create_timer(2).timeout
	credits.visible = true
	animation_player.play("credits_in")


func _on_avancar_pressed() -> void:
	som_virar_pagina.play()
	animation_player.play("main_bmg_out")
	await animation_player.animation_finished
	animation_player.play("credits_out")
	await animation_player.animation_finished
	await get_tree().create_timer(2).timeout
	credits.visible = false
	get_tree().change_scene_to_file("res://Cenas/mainMenu.tscn")
