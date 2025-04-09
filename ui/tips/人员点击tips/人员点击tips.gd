extends VBoxContainer

var target_people:People

func init(target_people:People):
	self.target_people=target_people
	$"人物详情".init(target_people)
	$"操作/双修".init(func(): return GlobalInfo.player.action_cool_times)
	$"操作/拜师".init(func(): return GlobalInfo.player.action_cool_times)
	$"操作/问好".init(func(): return GlobalInfo.player.action_cool_times)
	$"操作/道侣".init(func(): return GlobalInfo.player.action_cool_times)
	$"操作/结婚".init(func(): return GlobalInfo.player.action_cool_times)
	$"操作/交配".init(func(): return GlobalInfo.player.action_cool_times)
	pass


func _on_双修_pressed() -> void:
	if !is_instance_valid(target_people):
		print("对方已经死亡了")
		return
	if target_people.place_id!=GlobalInfo.player.place_id:
		print("对方已经离开")
		return
	var d={"people":GlobalInfo.player,"target_people":target_people}
	var decision=DoubleXiuDecision.new()
	var re=decision._before_execute(d)
	if DecisionEntity.is_success(re):
		decision.execute(d,true)
	else:
		# 不愿意的结果
		print(re)
		pass
	
	GlobalInfo.player.action_cool_times=GlobalInfo.player.action_cool_time.get_current()
	$"操作/双修".init(func(): return GlobalInfo.player.action_cool_times)
	pass # Replace with function body.


func _on_拜师_pressed() -> void:
	if target_people.place_id!=GlobalInfo.player.place_id:
		print("对方已经离开")
		return
	var d={"people":GlobalInfo.player,"target_people":target_people}
	var decision=BecomeTeacherDecision.new()
	var re=decision._before_execute(d)
	if DecisionEntity.is_success(re):
		decision.execute(d,true)
	else:
		# 不愿意的结果
		print(re)
		pass
	
	GlobalInfo.player.action_cool_times=GlobalInfo.player.action_cool_time.get_current()
	$"操作/拜师".init(func(): return GlobalInfo.player.action_cool_times)
	pass # Replace with function body.


func _on_问好_pressed() -> void:
	if target_people.place_id!=GlobalInfo.player.place_id:
		print("对方已经离开")
		return
	var d={"people":GlobalInfo.player,"target_people":target_people}
	var decision=FriendlyDecision.new()
	var re=decision._before_execute(d)
	if DecisionEntity.is_success(re):
		decision.execute(d,true)
	else:
		# 不愿意的结果
		print(re)
		pass
	
	GlobalInfo.player.action_cool_times=GlobalInfo.player.action_cool_time.get_current()
	$"操作/问好".init(func(): return GlobalInfo.player.action_cool_times)
	pass # Replace with function body.


func _on_道侣_pressed() -> void:
	if target_people.place_id!=GlobalInfo.player.place_id:
		print("对方已经离开")
		return
	var d={"people":GlobalInfo.player,"target_people":target_people}
	var decision=BecomeLoverDecision.new()
	var re=decision._before_execute(d)
	if DecisionEntity.is_success(re):
		decision.execute(d,true)
	else:
		# 不愿意的结果
		print(re)
		pass
	
	GlobalInfo.player.action_cool_times=GlobalInfo.player.action_cool_time.get_current()
	$"操作/道侣".init(func(): return GlobalInfo.player.action_cool_times)
	GlobalInfo.is_pause=false
	pass # Replace with function body.


func _on_结婚_pressed() -> void:
	if target_people.place_id!=GlobalInfo.player.place_id:
		print("对方已经离开")
		return
	var d={"people":GlobalInfo.player,"target_people":target_people}
	var decision=MarriageDecision.new()
	var re=decision._before_execute(d)
	if DecisionEntity.is_success(re):
		decision.execute(d,true)
	else:
		# 不愿意的结果
		print(re)
		pass
	
	GlobalInfo.player.action_cool_times=GlobalInfo.player.action_cool_time.get_current()
	$"操作/结婚".init(func(): return GlobalInfo.player.action_cool_times)
	pass # Replace with function body.


func _on_交配_pressed() -> void:
	if target_people.place_id!=GlobalInfo.player.place_id:
		print("对方已经离开")
		return
	var d={"people":GlobalInfo.player,"target_people":target_people}
	var decision=MateDecision.new()
	var re=decision._before_execute(d)
	if DecisionEntity.is_success(re):
		decision.execute(d,true)
	else:
		# 不愿意的结果
		print(re)
		pass
	
	GlobalInfo.player.action_cool_times=GlobalInfo.player.action_cool_time.get_current()
	$"操作/交配".init(func(): return GlobalInfo.player.action_cool_times)
	pass # Replace with function body.
