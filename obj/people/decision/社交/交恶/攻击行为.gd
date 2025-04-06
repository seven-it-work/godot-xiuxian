class_name AttackBehaviorDecision
extends DecisionEntity

var people:People
var target_people:People

func _init(people:People,target_people:People):
	self.people=people
	self.target_people=target_people

func _before_execute()->int:
	# 如果target_people是玩家 则加入到GlobalInfo.ai_interaction_queue队列中
	if target_people.is_player:
		GlobalInfo.ai_interaction_queue.append(self)
		return Result.FAILURE
	return Result.SUCCESS

# 判断是否需要逃跑
static func need_escape(people:People)->bool:
	# 获得当前血量占比百分比
	var current_hp_percentage=people.hp.get_current()/people.hp.max_v
	# 通过概率工具来判断血量占比是否成功
	if ObjectUtils.probability(current_hp_percentage*100):
		# 尝试逃跑
		if ObjectUtils.probability(people.fight_escape_probability.get_current()*100):
			return true
		else:
			# 记录debug日志:逃跑失败
			Log.debug(people.name_str+"逃跑失败")
			return false
	else:
		# 记录debug日志:"people不需要逃跑"
		Log.debug(people.name_str+"不需要逃跑")
		return false

func _execute()->int:
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
			# 如果需要逃跑
			if need_escape(people):
				Log.debug(people.name_str+"选择逃跑")
				return Result.SUCCESS
			else:
				people.do_attack(target_people)
				# 重置self_speed
				self_speed=people.attack_speed.get_current()
		if target_speed<=0:
			# 如果需要逃跑
			if need_escape(target_people):
				Log.debug(target_people.name_str+"选择逃跑")
				return Result.SUCCESS
			else:
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

func get_action_key()->String:
	return "攻击行为"

func _after_execute():
	pass



