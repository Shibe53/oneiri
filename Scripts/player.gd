extends CharacterBody2D

@onready var raycast = $RayCast2D

@export var MAX_SPEED = 50
@export var ACCELERATION = 100
@export var FRICTION = 200
@export var ROT_SPEED = 10
@export var ROT_ACC = 30
@export var ROT_FRICTION = 40

enum {
	MOVE,
	INTERACT,
	TRANSITION
}

var state = MOVE
var transition_fin = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Stats.decretum_acquired.connect(_on_decretum_acquired)

func _input(event):
	if event is InputEventMouseMotion and state == MOVE:
		if event.relative.x > 0:
			rotation += 0.01
		else:
			rotation -= 0.01

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta, MAX_SPEED)
			if Input.is_action_pressed("interact"):
				state = INTERACT
		INTERACT:
			if raycast.is_colliding():
				talk_state(raycast.get_collider())
				state = TRANSITION
			else:
				state = MOVE
		TRANSITION:
			if transition_fin:
				transition_fin = false
				await get_tree().create_timer(0.5).timeout
				state = MOVE

func move_state(delta, speed):
	var input_vector = Vector2.ZERO
	var forward = raycast.global_transform.y.normalized()
	var right = forward.rotated(PI/2)
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	input_vector = input_vector.normalized()
	
	var move_vector = input_vector.y * forward + input_vector.x * right
	
	move_and_collide(-move_vector * speed * delta)

func talk_state(area):
	var dialog = area.on_interact()
	for line in dialog:
		print(line)
		await _wait_talk()
	if area.get_type() == area.Types.DECRETUM:
		Stats.decreti += 1
		return
	transition_fin = true

func _wait_talk() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("interact"):
			return

func _on_decretum_acquired(value: Variant) -> void:
	match value:
		1:
			for line in ["MI", "MO", "MU"]:
				print(line)
				await _wait_talk()
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			pass
		6:
			pass

	transition_fin = true
