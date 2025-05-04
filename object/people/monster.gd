extends PeopleObj
class_name Monster


func mapDetailClick():
	print("点击了怪物，准备战斗")
	# 切换战斗core页面，将当前怪物战斗信息放入
	var main_node=get_node("/root/Main")
	main_node.do_fight()
	pass
