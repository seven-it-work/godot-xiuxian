extends CharacterBody2D

@export var speed = 300
@export var light_texture_scale = 5.0  # 控制视野范围

@onready var vision_light = $Light2D


func _physics_process(delta):
	# WASD移动
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input * speed
	move_and_slide()
	
	  # 让视野跟随鼠标
	var mouse_pos = get_global_mouse_position()
	vision_light.rotation = (mouse_pos - global_position).angle()
	
