extends Area2D

enum Types {
	NORMAL,
	DECRETUM,
	EXIT
}

@export var DIALOGUE: Array[String] = []
@export var TYPE: Types

func on_interact():
	return DIALOGUE
