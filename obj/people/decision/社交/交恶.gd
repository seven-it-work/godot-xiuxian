class_name SocialBadDecision
extends DecisionEntity

@onready var people:People
@onready var target_people:People
var attackBehaviorDecision:AttackBehaviorDecision

func get_action_key()->String:
	return "交恶"

func _init(people:People,target_people:People):
	self.people=people
	self.target_people=target_people

func _before_execute()->int:
	# 不能欺负10岁以下的人
	if target_people.get_age("year")<10:
		return Result.FAILURE
	return Result.SUCCESS

func _execute()->int:
	Log.debug(people.name_str+" 与 "+target_people.name_str+" 交恶 ")
	var weight_1={
		"攻击":GlobalInfo.people_map.values().size(),
		"辱骂":GlobalInfo.game_setting["最大人口数"],
		#"偷窃":10,
		# "脱离师徒关系":10,
		# "脱离道侣关系":10,
		# "脱离夫妻关系":10,
	}
	# 使用ObjectUtils.weight_selector权重选择器对weight_1进行选择
	var action=ObjectUtils.weight_selector(weight_1)[0]
	Log.debug(people.name_str+"执行动作"+action,weight_1)
	match action:
		"攻击":
			if attackBehaviorDecision==null:
				attackBehaviorDecision=AttackBehaviorDecision.new(people,target_people)
			return attackBehaviorDecision.execute()
		"辱骂":
			people.add_relation(target_people,randi_range(-10,1))
			return Result.SUCCESS
		_:
			Log.err("没有开发这个操作",action)
	return Result.SUCCESS

func _after_execute():
	people.action_cool_times=people.action_cool_time.get_current()
