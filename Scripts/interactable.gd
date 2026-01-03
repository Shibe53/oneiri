extends Area2D

enum Types {
	NORMAL,
	DECRETUM,
	EXIT
}

@export var DIALOGUE: Array[String] = []
@export var TYPE: Types = Types.NORMAL

func on_interact():
	return DIALOGUE

func get_type():
	return TYPE
