extends CharacterBody2D


# 移动速度
var speed = 300
func _physics_process(delta):
	# WASD移动
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input * speed
	move_and_slide()
	
