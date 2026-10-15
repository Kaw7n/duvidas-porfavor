extends Node3D

func _ready() -> void:
	$Fade/AnimationPlayer.play("fade_out");
