@tool
extends GrowthPropertie
class_name RandomPropertie
## 最小值
@export var min_v:float=0;
## 最大值
@export var max_v:float=0;

func save_json():
	var re:Dictionary=super.save_json()
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



func get_current():
	return randf_range(min_v,max_v);

func do_growth():
	var tempMin=min_v+get_growth()
	var tempMax=max_v+get_growth()
	if tempMin>tempMax:
		min_v=tempMax
		max_v=tempMin
	else:
		max_v=tempMax
		min_v=tempMin

# （max+min）/2/(1+风险系数*pow((max-min))/12
func get_current_score(风险系数=0.1)->float:
	return (max_v+min_v)/2/(1+风险系数*pow(max_v-min_v,2)/12)
