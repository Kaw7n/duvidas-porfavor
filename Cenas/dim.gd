extends ColorRect

@export var animation_player: AnimationPlayer

func _ready():
	Global.dim_in.connect(dim_in)
	Global.dim_out.connect(dim_out)

func dim_in():
	animation_player.play('dim_in')

func dim_out():
	animation_player.play('dim_out')
