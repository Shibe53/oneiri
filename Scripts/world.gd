extends Node2D

@export var player: NodePath

@onready var compass = $CanvasLayer/Compass
@onready var player_node = get_node(player)

func _process(delta):
	var ray = player_node.get_node("RayCast2D")
	compass.rotation = -ray.global_rotation
