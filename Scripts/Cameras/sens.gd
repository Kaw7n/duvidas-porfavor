extends HSlider

const sens_min = 0.0001
const sens_max = 0.002

func _ready() -> void:
	set_value_no_signal(inverse_lerp(sens_min, sens_max, Global.sens));
	
func _on_value_changed(value: float) -> void:
	Global.sens = lerp(sens_min, sens_max, value);

# Esse lerp aqui é para fazer uma regra de 3 entre
# a sensibilidade do slider e os valores da sensibilidade
#o inverse_lerp é só pra definir onde vai ficar o slider 
#ao iniciar o jogo, que é a sensi 0.0006 que a gente definiu a melhor
