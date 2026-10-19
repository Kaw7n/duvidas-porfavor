extends Node

# Variaveis globais do jogo
var sens = 0.0006;

var level = 0;
var i = 0; # Variavel De Animação npc
var npcs_animations_sequence = ["npc_fade_in","npc_fade_out"];

var click_switch = true;
var move_switch = true;
var zoom_switch= true;

var lives = 3; 

#Duvidas
var duvida_tutorial = false;
var duvida_cct = false;

#Animações
@warning_ignore("unused_signal")
signal dim_in
@warning_ignore("unused_signal")
signal dim_out
@warning_ignore("unused_signal")
signal pass_level
