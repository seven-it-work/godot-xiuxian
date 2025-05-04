extends Node
class_name Property

enum DATA_TYPE {BASE=0,RANDOM=1, BAR = 2}

@export var name_str:String=""
## 当前值
@export var current_value:float=0
@export var min_v:float=0;
@export var max_v:float=0;
## 成长最小值
@export var growth_min:float=0;
## 成长最大值
@export var growth_max:float=0;
## 成长倍率
@export var growth_factor:float=0;
## 已经成长值（每次分配成长都记录）
@export var grow_value:float=0;
## 成长次数
@export var growth_times:int=0;
## 数据型
@export var data_type:DATA_TYPE=DATA_TYPE.BASE

## 获取当前值
func get_current():
	if data_type==DATA_TYPE.BASE:
		return current_value;
	if data_type==DATA_TYPE.BAR:
		return current_value;
	if data_type==DATA_TYPE.RANDOM:
		return randf_range(min_v,max_v);
	pass
	
## 分配成长属性
func growth_add(num:float):
	grow_value+=num;
	var min_g_v=randf_range(0,num/2)
	var max_g_v=num-min_g_v
	growth_min+=min_g_v
	growth_max+=max_g_v
	pass

## 执行成长
func do_growth():
	growth_times+=1
	var g_v=randf_range(growth_min,growth_max)
	if data_type==DATA_TYPE.BASE:
		current_value+=g_v
		return g_v;
	if data_type==DATA_TYPE.BAR:
		max_v+=g_v
		return g_v;
	if data_type==DATA_TYPE.RANDOM:
		var min_g_v=randf_range(0,g_v/2)
		var max_g_v=g_v-min_g_v
		min_v+=min_g_v
		max_v+=max_g_v
		return g_v;
	return g_v
