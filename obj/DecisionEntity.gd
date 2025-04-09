@tool
class_name DecisionEntity
extends Node

# code说明：
# 200:成功
# 500:失败
# -1:系统错误（默认错误码）

static func Success(msg:String="成功",data:Dictionary={})->Dictionary:
	return {
		"code":200,
		"msg":msg,
		"data":data,
	}
	
static func Error(msg:String="失败",data:Dictionary={})->Dictionary:
	return {
		"code":500,
		"msg":msg,
		"data":data,
	}

	
static func ErrorCode(code:int,msg:String="失败",data:Dictionary={})->Dictionary:
	return {
		"code":code,
		"msg":msg,
		"data":data,
	}

static func is_success(dic:Dictionary)->bool:
	if dic:
		return dic.get("code",-1)==200
	return false

## 获取执行动作key
func get_action_key(dic:Dictionary={})->String:
	return ""

## 执行前的条件判断 0表示失败 200 表示成功（这里一般是ai的扩展行为）
func _before_execute(dic:Dictionary={})->Dictionary:
	return DecisionEntity.Success()

## 强制运行条件（不要在这里放置概率，ai和玩家都用这个）
func can_do_decision(dic:Dictionary={})->Dictionary:
	return DecisionEntity.Success()

## 执行后
func _after_execute(dic:Dictionary={}):
	pass

## 执行 0表示失败 200 表示成功
func _execute(dic:Dictionary={})->Dictionary:
	return DecisionEntity.Success()

## 执行 0表示失败 200 表示成功
func execute(dic:Dictionary={},ignore_before_execute:bool=false)->Dictionary:
	# 获取执行动作key，并将它记录到 statistics_map 中
	var action_key=get_action_key(dic)
	var can_do=can_do_decision(dic)
	if !is_success(can_do):
		GlobalInfo.statistics_map[action_key]=GlobalInfo.statistics_map.get(action_key,0)
		return can_do
	if !ignore_before_execute:
		var before_re=_before_execute(dic)
		if !DecisionEntity.is_success(before_re):
			GlobalInfo.statistics_map[action_key]=GlobalInfo.statistics_map.get(action_key,0)
			return before_re
	var re= _execute(dic)
	if action_key!="":
		if DecisionEntity.is_success(re):
			GlobalInfo.statistics_map[action_key]=GlobalInfo.statistics_map.get(action_key,0)+1
		else:
			GlobalInfo.statistics_map[action_key]=GlobalInfo.statistics_map.get(action_key,0)
	_after_execute(dic)
	return re
