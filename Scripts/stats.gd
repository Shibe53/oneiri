extends Node

signal decretum_acquired(value)

@export var decreti = 0:
	set(value):
		decreti = value
		emit_signal("decretum_acquired", decreti)
