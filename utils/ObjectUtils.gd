@tool
class_name  ObjectUtils

static func copy(obj:Object)->Object:
	return dict_2_inst(inst_2_dict(obj))
	
	
static func copyDic(dic:Dictionary)->Dictionary:
	var dic_new={}
	for key in dic:
		if dic[key] is Dictionary:
			dic_new[key]=dic[key]
		else:
			dic_new[key]=dict_2_inst(inst_2_dict(dic[key]))
	return dic_new


static func copyBean(soure:Dictionary,target:Object):
	for key in soure.keys():
		if target.has_method("set_"+key) or key in target:
			target.set(key,soure[key])

static func dict_2_inst(d:Dictionary):
	for i in d.keys():
		if d[i] is Dictionary:
			d[i]=dict_2_inst(d[i])
	if d.has("@path"):
		return dict_to_inst(d)
	else :
		return d;

static func inst_2_dict(obj:Object)->Dictionary:
	return dict_convert(inst_to_dict(obj).duplicate(true))

static func dict_convert(d:Dictionary)->Dictionary:
	for key in d.keys():
		if d[key] is Dictionary:
			d[key]=dict_convert(d[key])
		elif d[key] is Object:
			d[key]=dict_convert(inst_to_dict(d[key]))
	return d;

# 权重选择器
# d{数据:权重值}
static func weight_selector(d:Dictionary,size:int=1):
	var min=0;
	for v in d.values():
		min=minf(min,v)
	var temp_d={}
	for key in d:
		temp_d[key]=d[key]+abs(min)
	var total=temp_d.values().reduce(func(accum, number): return accum + number, 0)
	var re=[]
	for i in size:
		var temp=0;
		var value=randi_range(0,total)
		for key in temp_d:
			temp+=temp_d[key]
			if value<=temp:
				re.append(key)
				break
	return re;


# 概率计算器
static func probability(v:float,max:float=100)->bool:
	return randf_range(0,max)<=v;


## 自定义json创建实体方法
static func json_2_obj(json):
	if json is Array:
		return json.map(func(t): return json_2_obj(t))
	if json is Dictionary:
		if json.has("filename") && json["filename"]:
			var obj
			if json["filename"].ends_with(".gd"):
				obj=dict_to_inst({"@path":json["filename"]})
			else:
				obj=load(json["filename"]).instantiate()
			if obj.has_method("load_json"):
				obj.call("load_json",json)
			return obj;
		else:
			var re={}
			for key in json:
				re[key]=json_2_obj(json[key])
			return re
	# 如果是字符串，则返回字符串
	if json is String:
		return json
	print("不知道类型了",json)
	return json

## 自定义json转换方法
static func obj_2_json(obj):
	if obj is Dictionary:
		var re={}
		for key in obj:
			re[key]=obj_2_json(obj[key])
		return re;
	if obj is Array:
		return obj.map(func(t): return obj_2_json(t))
	
	if obj is Object && obj.has_method("save_json"):
		return obj.call("save_json")
	# 如果是字符串，则返回字符串
	if obj is String:
		return obj
	print("不知道类型了",obj)
	return obj


## 计算两个时间差
static func calculate_time_difference(timestamp1: int, timestamp2: int, unit: String = "天") -> int:
	# 获取两个时间戳对应的日期字典
	var date_dict1 = Time.get_date_dict_from_unix_time(timestamp1)
	var date_dict2 = Time.get_date_dict_from_unix_time(timestamp2)
	
	# 提取年、月、日
	var year1 = date_dict1.year
	var month1 = date_dict1.month
	var day1 = date_dict1.day
	
	var year2 = date_dict2.year
	var month2 = date_dict2.month
	var day2 = date_dict2.day
	
	# 计算两个日期之间的差异
	var years_diff = year2 - year1
	var months_diff = month2 - month1
	var days_diff = day2 - day1
	# 根据单位返回相应的时间差
	match unit:
		"年":
			return years_diff
		"月":
			return years_diff * 12 + months_diff
		"天":
			return (timestamp2 - timestamp1)/24/60/60
		_:
			return 0  # 默认返回 0，如果单位无效


	
## 从json中获取path的值 path用. 来表示子
static func get_nested_value(data:Dictionary,key_path:String):
	var keys=key_path.split(".")
	var current=data
	for key in keys:
		if current is Dictionary && key in current:
			current=current[key]
		else:
			return null
	return current;
