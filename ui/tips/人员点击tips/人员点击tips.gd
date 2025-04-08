extends VBoxContainer

var target_people:People

func init(target_people:People):
	# 点击人员就得暂停，防止人立刻了还能继续操作
	GlobalInfo.is_pause=true
	self.target_people=target_people
	$"人物详情".init(target_people)
	pass


func _on_双修_pressed() -> void:
	var d={"people":GlobalInfo.player,"target_people":target_people}
	var decision=DoubleXiuDecision.new()
	if decision._before_execute(d)==DecisionEntity.Result.SUCCESS:
		decision.execute(d,true)
	else:
		# 不愿意的结果
		pass
	
	GlobalInfo.player.action_cool_times=GlobalInfo.player.action_cool_time.get_current()
	$"操作/双修".init(func(): return GlobalInfo.player.action_cool_times)
	GlobalInfo.is_pause=false
	pass # Replace with function body.
