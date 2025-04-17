class_name Equipment
extends PanelContainer

@export var id:String=""
@export var name_str:String=""
@export var description:String=""

## 强化等级
@export var lv:int=0
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
	var excelData=excel_all_data.get(id).duplicate(true)
	_属性设置(excelData)
	## lv设置
	for i in excelData.get("等级"):
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
	if excelData.has("攻击力"):
		var 攻击力:Dictionary=excelData.get("攻击力")
		if !ObjectUtils.is_empty(攻击力):
			self.atk.min_v=攻击力.min_v
			self.atk.max_v=攻击力.max_v
			self.atk.min_growth=攻击力.min_growth
			self.atk.max_growth=攻击力.max_growth
			self.atk.growth_factor=攻击力.growth_factor
	if excelData.has("防御力"):
		var 防御力:Dictionary=excelData.get("防御力")
		if !ObjectUtils.is_empty(防御力):
			self.def.min_v=防御力.min_v
			self.def.max_v=防御力.max_v
			self.def.min_growth=防御力.min_growth
			self.def.max_growth=防御力.max_growth
			self.def.growth_factor=防御力.growth_factor
	if excelData.has("装备条件"):
		var 装备条件:Array=excelData.get("装备条件")
		if !ObjectUtils.is_empty(装备条件):
			self.equipmentConditions=装备条件

func do_growth():
	self.lv+=1
	hp.do_growth()
	atk.do_growth()
	def.do_growth()
	

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
