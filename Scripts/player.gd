extends CharacterBody2D

@onready var raycast = $RayCast2D
@onready var dialogue = get_parent().get_node("Dialogue")
@onready var steps = $Steps

@export var SPEED = 20
@export var ROT_SPEED = 0.001

enum {
	MOVE,
	INTERACT,
	TRANSITION
}

var state = MOVE
var transition_fin = false
var playing = false

func _ready():
	Stats.decretum_acquired.connect(_on_decretum_acquired)

func _input(event):
	if event is InputEventMouseMotion and state == MOVE:
		rotation += ROT_SPEED * event.relative.x

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
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
				await get_tree().create_timer(0.25).timeout
				state = MOVE

func move_state(delta):
	var input_vector = Vector2.ZERO
	var forward = raycast.global_transform.y.normalized()
	var right = forward.rotated(PI/2)
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	input_vector = input_vector.normalized()
	
	var move_vector = input_vector.y * forward + input_vector.x * right
	var collision = move_and_collide(-move_vector * SPEED * delta)
	
	if collision is not KinematicCollision2D and move_vector.length() > 0 and not playing:
		playing = true;
		await play_steps()
		playing = false;

func play_steps():
	steps.play(randi() % 4)
	await get_tree().create_timer(1.0).timeout
	steps.stop()

func talk_state(area):
	if area.get_type() == area.Types.EXIT:
		Stats.act += 1
		return
	if area.get_type() == area.Types.DECRETUM or area.get_type() == area.Types.DOOR:
		await play_knock(area.get_parent().get_node("Knock"))
	await dialogue.show(area.on_interact())
	if area.get_type() == area.Types.DECRETUM:
		Stats.decreti += 1
		return
	transition_fin = true

func play_knock(player):
	player.play((randi() % 4) * 3.0)
	await get_tree().create_timer(1.0).timeout
	await dialogue.show(["..."])
	player.stop()

func _on_decretum_acquired(value: Variant) -> void:
	match value:
		0:
			pass
		1:
			await dialogue.show(["MI", "MO", "MU"])
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
