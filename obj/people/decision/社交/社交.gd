class_name SocialDecision
extends DecisionEntity

var socialGoodDecision:SocialGoodDecision=SocialGoodDecision.new()
var socialBadDecision:SocialBadDecision=SocialBadDecision.new()

func get_action_key(dic:Dictionary={})->String:
	return "社交"

func _before_execute(dic:Dictionary={})->int:
	if !dic.has("people"):
		Log.err("参数错误")
		return Result.FAILURE
	var people=dic.get("people")
	
	# 怀孕大概率不社交 规避风险
	if people.is_pregnancy():
		if ObjectUtils.probability(80,100):
			return Result.FAILURE
		
	if GlobalInfo.place_map.is_empty():
		return Result.FAILURE
	var place:Place=GlobalInfo.place_map[people.place_id]
	# 随机选择一个人
	var target_people_list=place.get_other_people_id_list(people.id)
	if target_people_list.is_empty():
		return Result.FAILURE
	var target_id=target_people_list.pick_random()
	var target_people=GlobalInfo.get_people_by_id(target_id)
	if target_people==null:
		# 表示这个人死亡了不进行操作了
		return Result.FAILURE
	dic["target_people"]=target_people
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
	
	var weight_1={
		"交好":GlobalInfo.game_setting["最大人口数"],
		"交恶":GlobalInfo.people_map.values().size(),
	}
	if people.relation.has(target_people.id):
		var re=people.relation.get(target_people.id)
		if re.relation_value>0:
			weight_1["交好"]+=re.relation_value
		else:
			weight_1["交恶"]-=re.relation_value
	var temp=ObjectUtils.weight_selector(weight_1)[0]
	match temp:
		"交好":
			return socialGoodDecision.execute(dic)
			
		"交恶":
			return socialBadDecision.execute(dic)
			
	return Result.FAILURE

func _after_execute(dic:Dictionary={}):
	return Result.SUCCESS
