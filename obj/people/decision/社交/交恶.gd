class_name SocialBadDecision
extends DecisionEntity

var attackBehaviorDecision:AttackBehaviorDecision=AttackBehaviorDecision.new()

func get_action_key(dic:Dictionary={})->String:
	return "交恶"


func _before_execute(dic:Dictionary={})->int:
	if !dic.has("people"):
		Log.err("参数错误")
		return Result.FAILURE
	var people=dic.get("people")
	
	if !dic.has("target_people"):
		Log.err("参数错误")
		return Result.FAILURE
	var target_people=dic.get("target_people")
	# 不能欺负10岁以下的人
	if target_people.get_age("year")<10:
		return Result.FAILURE
	return Result.SUCCESS

func _execute(dic:Dictionary={})->int:
	if !dic.has("people"):
		Log.err("参数错误")
		return Result.FAILURE
	var people=dic.get("people")
	
	if !dic.has("target_people"):
		Log.err("参数错误")
		return Result.FAILURE
	var target_people=dic.get("target_people")
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
			return attackBehaviorDecision.execute(dic)
		"辱骂":
			people.add_relation(target_people,randi_range(-10,1))
			return Result.SUCCESS
		_:
			Log.err("没有开发这个操作",action)
	return Result.SUCCESS

func _after_execute(dic:Dictionary={}):
	if !dic.has("people"):
		Log.err("参数错误")
		return Result.FAILURE
	var people=dic.get("people")
	
	if !dic.has("target_people"):
		Log.err("参数错误")
		return Result.FAILURE
	var target_people=dic.get("target_people")
	people.action_cool_times=people.action_cool_time.get_current()
