extends Area2D

enum Types {
	WALL,
	OBJECT,
	DOOR,
	DECRETUM,
	EXIT
}

@export var DIALOGUE: Array[String] = []
@export var TYPE: Types = Types.WALL

func on_interact() -> Array[String]:
	return DIALOGUE

func get_type():
	return TYPE
