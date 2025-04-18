class_name Equipment
extends PanelContainer

@export var id:String=""
@export var name_str:String=""
@export var description:String=""

## 等级
@export var lv:BarPropertie
## 可以强化等级(current当前强化级，max 最大强化等级)
@export var intensify:BarPropertie
## 生命值
@export var hp:GrowthPropertie
## 攻击力
@export var atk:RandomPropertie
## 防御力
@export var def:RandomPropertie
## 是否装备条件 {"property":"lv","value":1,"symbol":"<"}
@export var equipmentConditions:Array=[]

## 获取excel中原始数据
func get_excel_original_data():
	Log.err("子类必须实现此方法")
	return {}

func get_type()->String:
	return "Equipment"

func coverage_data_by_excel(id:int):
	var excel_all_data:Dictionary=self.get_excel_original_data().data
	if !excel_all_data.has(id):
		Log.err("没有对应id为：[%s]数据"%id,excel_all_data)
		return self
	if ObjectUtils.is_empty(self.hp):
		self.hp=GrowthPropertie.new()
	if ObjectUtils.is_empty(self.atk):
		self.atk=RandomPropertie.new()
	if ObjectUtils.is_empty(self.def):
		self.def=RandomPropertie.new()
	if ObjectUtils.is_empty(self.intensify):
		self.intensify=BarPropertie.new()
	if ObjectUtils.is_empty(self.lv):
		self.lv=BarPropertie.new()
	var excelData=excel_all_data.get(id).duplicate(true)
	_属性设置(excelData)
	## 强化设置
	for i in self.intensify.get_current():
		do_intensify()
	## 升级设置
	for i in self.lv.get_current():
		do_growth()
	return self

func _属性设置(excelData:Dictionary):
	self.id=get_type()+"_%s"%excelData.get("id")
	self.name_str=excelData.get("名称")
	self.description=excelData.get("描述")
	if excelData.has("生命值"):
		var 生命值:Dictionary=excelData.get("生命值")
		if !ObjectUtils.is_empty(生命值):
			self.hp.min_growth=生命值.min_growth
			self.hp.max_growth=生命值.max_growth
			self.hp.growth_factor=生命值.growth_factor
			self.hp.random_add_growth(生命值.score)
	if excelData.has("攻击力"):
		var 攻击力:Dictionary=excelData.get("攻击力")
		if !ObjectUtils.is_empty(攻击力):
			self.atk.min_v=攻击力.min_v
			self.atk.max_v=攻击力.max_v
			self.atk.min_growth=攻击力.min_growth
			self.atk.max_growth=攻击力.max_growth
			self.atk.growth_factor=攻击力.growth_factor
			self.atk.random_add_growth(攻击力.score)
	if excelData.has("防御力"):
		var 防御力:Dictionary=excelData.get("防御力")
		if !ObjectUtils.is_empty(防御力):
			self.def.min_v=防御力.min_v
			self.def.max_v=防御力.max_v
			self.def.min_growth=防御力.min_growth
			self.def.max_growth=防御力.max_growth
			self.def.growth_factor=防御力.growth_factor
			self.def.random_add_growth(防御力.score)
	if excelData.has("强化等级"):
		var 强化等级:Dictionary=excelData.get("强化等级")
		if !ObjectUtils.is_empty(强化等级):
			self.intensify.min_v=强化等级.min_v
			self.intensify.max_v=强化等级.max_v
			self.intensify.current=强化等级.current
			self.intensify.min_growth=强化等级.min_growth
			self.intensify.max_growth=强化等级.max_growth
			self.intensify.growth_factor=强化等级.growth_factor
			self.intensify.random_add_growth(强化等级.score)
	if excelData.has("等级"):
		var 等级:Dictionary=excelData.get("等级")
		if !ObjectUtils.is_empty(等级):
			self.lv.min_v=等级.min_v
			self.lv.max_v=等级.max_v
			self.lv.current=等级.current
			self.lv.min_growth=等级.min_growth
			self.lv.max_growth=等级.max_growth
			self.lv.growth_factor=等级.growth_factor
			self.lv.score=等级.score
			self.lv.random_add_growth(等级.score)
	if excelData.has("装备条件"):
		var 装备条件:Array=excelData.get("装备条件")
		if !ObjectUtils.is_empty(装备条件):
			self.equipmentConditions=装备条件

## 升级操作
func do_growth():
	self.lv.add_current(1)
	hp.do_growth()
	atk.do_growth()
	def.do_growth()
	
## 强化操作
func do_intensify():
	self.intensify.add_current(1)
	hp.random_add_growth(1)
	hp.random_add_growth(1)
	hp.random_add_growth(1)
	
func can_equipment(p:People)->bool:
	if p==null:
		Log.err("人员参数为null")
		return false
	if ObjectUtils.is_empty(equipmentConditions):
		return true;
	var p_json=ObjectUtils.obj_2_json(p)
	for i in equipmentConditions:
		var property=ObjectUtils.get_nested_value(p_json,i.property)
		if property==null:
			Log.warn("属性值不存在",i.property)
		if i.symbol=="<":
			if property<i.value:
				continue
			else:
				return false
		elif  i.symbol=="<=":
			if property<=i.value:
				continue
			else:
				return false
		elif  i.symbol==">":
			if property>i.value:
				continue
			else:
				return false
		elif i.symbol==">=":
			if property>=i.value:
				continue
			else:
				return false
		elif i.symbol=="!=":
			if property!=i.value:
				continue
			else:
				return false
		elif i.symbol=="==":
			if property!=i.value:
				continue
			else:
				return false
		else:
			Log.err("不支持这个比较符合",i.symbol)
	return true

func _merged(excelData1:Dictionary,excelData2:Dictionary,key:String,defalutValue):
	excelData1.set(key,ObjectUtils.merge(excelData1.get(key,defalutValue),excelData2.get(key,defalutValue)))
	

func _ready() -> void:
	pass

## 得分计算公式：等级+hp+atk+def
func get_score()->float:
	return lv.current+hp.score+atk.score+def.score+intensify.current




func save_json():
	var re:Dictionary={}
	re.merge({
		"filename" : get_script().resource_path.replace(".gd",".tscn"),
		"id":self.id,
		"name_str":self.name_str,
		"lv":ObjectUtils.obj_2_json(lv),
		"intensify":ObjectUtils.obj_2_json(intensify),
		"hp":ObjectUtils.obj_2_json(hp),
		"atk":ObjectUtils.obj_2_json(atk),
		"def":ObjectUtils.obj_2_json(def),
		"equipmentConditions":ObjectUtils.obj_2_json(equipmentConditions)
	},true)
	return re
	
func load_json(json:Dictionary):
	id=json["id"]
	name_str=json["name_str"]
	lv=ObjectUtils.json_2_obj(json["lv"])
	intensify=ObjectUtils.json_2_obj(json["intensify"])
	hp=ObjectUtils.json_2_obj(json["hp"])
	atk=ObjectUtils.json_2_obj(json["atk"])
	def=ObjectUtils.json_2_obj(json["def"])
	equipmentConditions=ObjectUtils.obj_2_json(json.get("equipmentConditions",[]))
