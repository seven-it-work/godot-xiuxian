class_name SocialGoodDecision
extends DecisionEntity

var doubleXiuDecision:DoubleXiuDecision=DoubleXiuDecision.new()
var becomeTeacherDecision:BecomeTeacherDecision=BecomeTeacherDecision.new()
var becomeLoverDecision:BecomeLoverDecision=BecomeLoverDecision.new()
var marriageDecision:MarriageDecision=MarriageDecision.new()
var mateDecision:MateDecision=MateDecision.new()
var friendlyDecision:FriendlyDecision=FriendlyDecision.new()
var argumentDecision:ArgumentDecision=ArgumentDecision.new()

func get_action_key(dic:Dictionary={})->String:
	return "交好"

func _before_execute(dic:Dictionary={})->Dictionary:
	return DecisionEntity.Success()

func _execute(dic:Dictionary={})->Dictionary:
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	
	if !dic.has("target_people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var target_people=dic.get("target_people")
	Log.debug(people.name_str+" 与 "+target_people.name_str+" 交好 ")
	var weight_1={
		"问好":70,
		"论道":50,
		"切磋":30,
		#待开发"送礼":10,
		"双修":10,
		"拜师":10,
		"成为道侣":10,
		"结婚":10,
		"交配":10,
	}
	# 特殊关系影响
	match target_people.id:
		people.shi_fu:
			weight_1["问好"]+=50
			weight_1["双修"]-=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		people.father:
			weight_1["问好"]+=50
			weight_1["双修"]-=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		people.mother:
			weight_1["问好"]+=50
			weight_1["双修"]-=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		people.child_list:
			weight_1["切磋"]+=10
			weight_1["双修"]-=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		people.wife_list:
			weight_1["双修"]+=10
			weight_1["交配"]+=30
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		people.lover_list:
			weight_1["双修"]+=10
			weight_1["交配"]+=20
			weight_1["结婚"]+=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
		_:
			# 没有深度关系
			pass
	# 关系值影响
	if people.relation.has(target_people.id):
		var re:Relation=people.relation.get(target_people.id)
		weight_1["问好"]+=re.relation_value*0.1
		weight_1["论道"]+=re.relation_value*0.1
		weight_1["切磋"]+=re.relation_value*0.1
		weight_1["双修"]+=re.relation_value*0.5
		weight_1["拜师"]+=re.relation_value*0.1
		weight_1["成为道侣"]+=re.relation_value*0.4
		weight_1["结婚"]+=re.relation_value*0.3
		weight_1["交配"]+=re.relation_value*0.2
	# 怀孕了不能做
	if !target_people.is_man:
		if target_people.pregnancy.get_current()>0:
			weight_1["交配"]-=10
			weight_1["双修"]-=10
	if !people.is_man:
		if people.pregnancy.get_current()>0:
			weight_1["交配"]-=10
			weight_1["双修"]-=10
	# 如果是同性，双修=0 成为道侣=0 结婚=0 交配=0
	if target_people.is_man==people.is_man:
		weight_1["交配"]-=10
		weight_1["双修"]-=10
		weight_1["成为道侣"]-=10
		weight_1["结婚"]-=10
	
	var action=ObjectUtils.weight_selector(weight_1)[0]
	Log.debug(people.name_str+"执行动作"+action,weight_1)
	match action:
		"问好":
			return friendlyDecision.execute(dic)
		"论道":
			return argumentDecision.execute(dic)
		"切磋":
			## todo 战斗切磋
			people.add_relation(target_people,randi_range(-3,6))
			return DecisionEntity.Success()
		#"送礼":
			#pass
		"双修":
			return doubleXiuDecision.execute(dic)
		"拜师":
			return becomeTeacherDecision.execute(dic)
		"成为道侣":
			return becomeLoverDecision.execute(dic)
		"结婚":
			return marriageDecision.execute(dic)
		"交配":
			return mateDecision.execute(dic)
		_:
			Log.err("没有开发这个操作",action)
	return DecisionEntity.Success()

func _after_execute(dic:Dictionary={}):
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	
	if !dic.has("target_people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var target_people=dic.get("target_people")
	people.action_cool_times=people.action_cool_time.get_current()
