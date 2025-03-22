## 进度条属性（生命值这种）
@tool
class_name BarPropertie
extends GrowthPropertie
## 最小值（一般为0）
@export var min_v:float=0;
## 最大值
@export var max_v:float=0;

## 将最大值进行成长，同时当前值也会增加
func do_growth():
	var g_value=self.get_growth()
	self.max_v+=g_value;
	self.current+=g_value

## 增加当前值
func add_current(v:float):
	super.add_current(v);
	self.current=minf(self.current,max_v)



func save_json():
	var re:Dictionary=super.save_json()
	var t=get_scene_file_path()
	re.merge({
		"filename" : get_script().resource_path,
		"min_v":self.min_v,
		"max_v":self.max_v,
	},true)
	return re
	
func load_json(json:Dictionary):
	super.load_json(json)
	min_v=json["min_v"]
	max_v=json["max_v"]
	
