extends Node
class_name DoAction
## 执行动作的冷却周期（帧）
@export var do_action_speed:int=600
var current:int=0;

func _process(delta: float) -> void:
	var main_node=get_node("/root/Main")
	if main_node.is_puase():
		return
	if current>=do_action_speed:
		do_action()
		current=0
		return
	current+=main_node.action_speed

func do_action():
	pass
