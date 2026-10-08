extends Control

# Barulho do iniciar
func Som1() -> void:
	$BotaoIniciarAudio.play();

# Barulho do Configurar
func Som2() -> void:
	$BotaoConfigAudio.play();
	
# Barulho do sair
func Som3() -> void:
	$BotaoSairAudio.play();

# Sistema de passar o mouse e fazer barulho
func _ready() -> void:
	$BotaoIniciar.mouse_entered.connect(Som1);
	$BotaoConfig.mouse_entered.connect(Som2);
	$BotaoSair.mouse_entered.connect(Som3);
	pass # Replace with function body.
	
# /////////

# O Botao de iniciar o jogo
func _on_texture_button_pressed() -> void: # Botão De Inciar
	$Fade.show();
	$Fade/Timer.start();
	$Fade/AnimationPlayer.play("fade_in");

# O Botão de opcs que depois eu faço
func _on_texture_button_2_pressed() -> void: # Botão de Configurações 
	pass # Replace with function body.

# O Botão Pra sair 
func _on_texture_button_3_pressed() -> void: # Botão de quitar
	get_tree().quit()

# Fade in para Fade Out
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://sala_de_aula.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
