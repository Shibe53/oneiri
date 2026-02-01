extends Node2D

@export var player: NodePath

@onready var dialogue = $Dialogue
@onready var compass = $CanvasLayer/Compass
@onready var player_node: Node = null
@onready var text_box = $CanvasLayer/HintLabel

var margin = 10

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if player != NodePath(""):
		player_node = get_node(player)
	
	Stats.act_changed.connect(_on_change_act)
	if Stats.act == 0:
		set_process(false)
		Stats.act += 1

func _process(_delta):
	var ray = player_node.get_node("RayCast2D")
	compass.rotation = -ray.global_rotation
	var screen_size = get_viewport().get_visible_rect().size
	
	var center = screen_size / 2
	var half_size = text_box.size / 2
	var rx = center.x - half_size.x - margin
	var ry = center.y - half_size.y - margin

	var ray_dir = ray.global_transform.y.normalized()
	var angle = atan2(ray_dir.y, ray_dir.x)

	var pos = Vector2(
		center.x + rx * cos(angle),
		center.y + ry * sin(angle)
	)
	var rot = atan2(ry * cos(angle), -rx * sin(angle))
	text_box.position = pos
	text_box.rotation = rot

func _on_change_act(value: Variant) -> void:
	match value:
		1:
			await dialogue.show(["ACT I", "ASIYAH"])
			get_tree().change_scene_to_file("res://World/asiyah.tscn")
		2:
			await dialogue.show(["ACT II", "YETZIRAH"])
			get_tree().change_scene_to_file("res://World/yetzirah.tscn")
		3:
			await dialogue.show(["ACT III", "BRIYAH"])
			get_tree().change_scene_to_file("res://World/briyah.tscn")
		4:
			await dialogue.show(["EPILOGUE", "ATZILUTH"])
			get_tree().change_scene_to_file("res://World/atziluth.tscn")
