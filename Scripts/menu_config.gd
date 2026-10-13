extends Panel

@onready var menu_config: Panel = $"."

func _ready() -> void:
	menu_config.visible = false; #Deixar config escondido
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"): 
		switchMenu()

func switchMenu():
	if menu_config.visible == false:
		menu_config.visible = true;
		Global.click_switch = false;
		Global.move_switch = false;
		Global.zoom_switch = false;
	else:
		menu_config.visible = false;
		Global.click_switch = true;
		Global.move_switch = true;
		Global.zoom_switch = true;
		
	# deve ter uma maneira mais prática de fazer isso
	# mas se vocês acharem que isso realmente pode ta
	# atrapalhando o codigo do jogo, eu posso ir atras
	# de uma solução, mas se isso so foi deixar o codigo 
	# feio, por enquanto, vamos deixar essa otimização
	# no desejavel.
	
func _on_exit_config_pressed() -> void: #Menu Xzinho
	switchMenu()
	
func _on_exit_game_pressed() -> void: # Botão de encerrar
	get_tree().quit()
