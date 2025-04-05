@tool
class_name DecisionEntity
extends Node

enum Result{
	SUCCESS=200,
	FAILURE=0
}

## 获取执行动作key
func get_action_key()->String:
	return ""

## 执行前的条件判断 0表示失败 200 表示成功
func _before_execute()->int:
	return Result.SUCCESS

## 执行后
func _after_execute():
	pass

## 执行 0表示失败 200 表示成功
func _execute()->int:
	return Result.SUCCESS

## 执行 0表示失败 200 表示成功
func execute()->int:
	if _before_execute()==Result.FAILURE:
		return Result.FAILURE
	var re= _execute()
	if re==Result.SUCCESS:
		# 获取执行动作key，并将它记录到 statistics_map 中
		var action_key=get_action_key()
		if action_key!="":
			GlobalInfo.statistics_map[action_key]=GlobalInfo.statistics_map.get(action_key,0)+1
	_after_execute()
	return re
