extends Control

@onready var menu_config: Panel = $MenuConfig

# Barulho do iniciar
func som_1() -> void:
	$BotaoIniciarAudio.play();
# Barulho do Configurar
func som_2() -> void:
	$BotaoConfigAudio.play();
# Barulho do sair
func som_3() -> void:
	$BotaoSairAudio.play();

# Sistema de passar o mouse e fazer barulho
func _ready() -> void:
	$BotaoIniciar.mouse_entered.connect(som_1);
	$BotaoConfig.mouse_entered.connect(som_2);
	$BotaoSair.mouse_entered.connect(som_3);
	pass # Replace with function body.
	
# /////////

# O Botao de iniciar o jogo
func _on_texture_button_pressed() -> void: # Botão De Inciar
	$Fade.show();
	$Fade/Timer.start();
	$Fade/AnimationPlayer.play("fade_in");

# O Botão de opcs que depois eu faço
func _on_texture_button_2_pressed() -> void: # Botão de Configurações 
	menu_config.visible = true;

# O Botão Pra sair 
func _on_texture_button_3_pressed() -> void: # Botão de quitar
	get_tree().quit()

# Fade in para Fade Out
func _on_timer_timeout() -> void:
	Global.lives = 3; 
	Global.level = 0;
	Global.duvida_tutorial = false;
	Global.duvida_cct = false;
	Global.duvida_pato_fred = false;
	Global.duvida_ccs = false;
	Global.duvida_ccg = false;
	get_tree().change_scene_to_file("res://Cenas/sala_de_aula.tscn")
