extends CharacterBody2D

@export var speed = 100



func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# WASD移动
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input * speed
	move_and_slide()
	
	# 让视野跟随鼠标
	var mouse_pos = get_global_mouse_position()
	rotation = (mouse_pos - global_position).angle()
