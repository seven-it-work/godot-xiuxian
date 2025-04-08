@tool
extends BasePropertie
class_name GrowthPropertie
## 成长最小值
@export var min_growth:float=0;
## 成长最大值
@export var max_growth:float=0;
## 成长系数
@export var growth_factor:float=0;
## 成长评分
@onready var score:float=0;

## 继承父母
# 两种模式
# 1、区间混合(稳定)
# max_growth=(father.max_growth+mother.max_growth)/2
# 然后再上下波动-5%~5%
# 随机择优
# 父亲权重=范围(0,1)
# max_growth=(father.max_growth*父亲权重+mother.max_growth*(1-mother.max_growth))
# 然后再上下波动-2%~2%
# 然后再有1%概率突变，突变再上下波动-5%~5%
func inherit_parent(father:GrowthPropertie,mother:GrowthPropertie):
	if randi_range(0,1)==0:
		# 区间混合
		max_growth=(father.max_growth+mother.max_growth)/2
		min_growth=(father.min_growth+mother.min_growth)/2
		# 然后再上下波动-5%~5%
		max_growth=max_growth*(1+randf_range(-0.05,0.05))
		min_growth=min_growth*(1+randf_range(-0.05,0.05))
	else:
		# 随机择优
		var father_weight=randf_range(0,1)
		max_growth=father.max_growth*father_weight+mother.max_growth*(1-father_weight)
		min_growth=father.min_growth*father_weight+mother.min_growth*(1-father_weight)
		# 再上下波动-2%~2%
		max_growth=max_growth*(1+randf_range(-0.02,0.02))
		min_growth=min_growth*(1+randf_range(-0.02,0.02))
	# 然后再有1%概率突变，突变再上下波动-5%~5%
	if ObjectUtils.probability(1):
		max_growth=max_growth*(1+randf_range(-0.05,0.05))
		min_growth=min_growth*(1+randf_range(-0.05,0.05))

func save_json():
	var re:Dictionary=super.save_json()
	re.merge({
		"filename" : get_script().resource_path,

		"min_growth":self.min_growth,
		"max_growth":self.max_growth,
		"growth_factor":self.growth_factor,
		"score":self.score,
	},true)
	return re
	
func load_json(json:Dictionary):
	super.load_json(json)
	min_growth=json["min_growth"]
	max_growth=json["max_growth"]
	growth_factor=json["growth_factor"]
	score=json["score"]
	

## 获得成长值
func get_growth()->float:
	return randf_range(min_growth,max_growth)*growth_factor

## 随机分配成长值（将随机分配给min、max）
func random_add_growth(growth_num:float):
	self.score+=growth_num
	var remaining=growth_num;
	for i in 200:
		if remaining>0:
			var add=randf_range(0,remaining)
			remaining-=add;
			if randi_range(0,1)==0:
				max_growth+=add;
			else:
				min_growth+=add;
#	还没有分配完，采用整数分配策略，每次分配步长为1 小于1 直接分配 并结束分配
	while remaining>0:
		var add=1
		if remaining<add:
			add=remaining
		remaining-=add
		if randi_range(0,1)==0:
			max_growth+=add;
		else:
			min_growth+=add;

## 执行成长
func do_growth():
	current+=get_growth()
