class_name SocialBadDecision
extends DecisionEntity

@onready var people:People
@onready var target_people:People

func get_action_key()->String:
	return "交恶"

func _init(people:People,target_people:People):
	self.people=people
	self.target_people=target_people

func _before_execute()->int:
	return Result.FAILURE

func _execute()->int:
	Log.debug(people.name_str+" 与 "+target_people.name_str+" 交恶 ")
	var weight_1={
		"攻击":GlobalInfo.people_map.values().size(),
		"辱骂":GlobalInfo.game_setting["最大人口数"],
		#"偷窃":10,
	}
	# 使用ObjectUtils.weight_selector权重选择器对weight_1进行选择
	var action=ObjectUtils.weight_selector(weight_1)[0]
	Log.debug(people.name_str+"执行动作"+action,weight_1)
	match action:
		"攻击":
			# 调用self和target的集气速度
			var self_speed=people.attack_speed.get_current()
			var target_speed=target_people.attack_speed.get_current()
			while true:
				# slef_speed-1
				self_speed-=1
				# target_speed-1
				target_speed-=1
				# 如果self_speed<=0 则self攻击target
				if self_speed<=0:
					people.do_attack(target_people)
					# 重置self_speed
					self_speed=people.attack_speed.get_current()
				if target_speed<=0:
					target_people.do_attack(people)
					# 重置target_speed
					target_speed=target_people.attack_speed.get_current()
				# 如果self的生命值或者targbet的生命值小于0退出循环
				if people.hp.get_current()<=0 or target_people.hp.get_current()<=0:
					break
			# 如果self的生命值小于0，则战斗失败
			if people.hp.get_current()<=0:
				target_people._after_beat(people)
			# 如果target_people的生命值小于0，则战斗胜利
			if target_people.hp.get_current()<=0:
				people._after_beat(people)
			return Result.SUCCESS
		"辱骂":
			return Result.SUCCESS
		_:
			Log.err("没有开发这个操作",action)
	return Result.SUCCESS

func _after_execute():
	people.action_cool_times=people.action_cool_time.get_current()
