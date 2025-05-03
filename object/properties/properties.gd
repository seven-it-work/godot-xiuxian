extends Node
class_name Property

enum DATA_TYPE {BASE=0,RANDOM=1, BAR = 2}

@export var name_str:String=""
## 当前值
@export var current_value:float=0
@export var min_v:float=0;
@export var max_v:float=0;
## 成长最下值
@export var growth_min:float=0;
## 成长最大值
@export var growth_max:float=0;
## 成长倍率
@export var growth_factor:float=0;
## 已经成长值（每次成长都记录）
@export var grow_value:float=0;
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
