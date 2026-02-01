extends Node

signal decretum_acquired(value)
signal act_changed(value)

@export var decreti = 0:
	set(value):
		decreti = value
		emit_signal("decretum_acquired", decreti)

@export var act = 0:
	set(value):
		act = value
		emit_signal("act_changed", act)
	get():
		return act
