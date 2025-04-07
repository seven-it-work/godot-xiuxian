extends VBoxContainer

func init(people:People):
	# 点击人员就得暂停，防止人立刻了还能继续操作
	GlobalInfo.is_pause=true
	$"人物详情".init(people)
	pass
