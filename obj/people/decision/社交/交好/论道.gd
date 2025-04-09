class_name ArgumentDecision
extends DecisionEntity


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
	
	## 增加关系值
	people.add_relation(target_people,randi_range(-5,10))
	target_people.add_relation(people,randi_range(-5,10))
	return DecisionEntity.Success()

func get_action_key(dic:Dictionary={})->String:
	return "论道"

func _after_execute(dic:Dictionary={}):
	pass
