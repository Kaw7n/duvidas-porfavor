extends AnimatedSprite3D


@export var camera_3d: Camera3D
@export var area_3d: Area3D
@export var animacoes_npcs: AnimationPlayer

#Sequencia das animações : 
var animacoes_npcs_array = ["npc_talk_1", "npc_talk_2", "npc_talk_3", "npc_fade_out"];
var i = 0;

func _ready():
	camera_3d.click_npc.connect(_on_click_npc);

func _on_click_npc(collider):
	if i >= animacoes_npcs_array.size():
		return;
	
	animacoes_npcs.play(animacoes_npcs_array[i]);
	i+= 1;
	
