extends Node

@export var labelPath: NodePath
@onready var label = get_node(labelPath)

func show(dialog):
	for line in dialog:
		label.text = line
		await wait()
	label.text = ""

func wait():
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("interact"):
			return
