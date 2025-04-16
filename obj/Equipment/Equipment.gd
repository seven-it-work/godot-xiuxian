class_name Equipment
extends PanelContainer

@export var id:String=""
@export var name_str:String=""

## 强化等级
@export var lv:int=0
## 生命值
@export var hp:GrowthPropertie
## 攻击力
@export var atk:RandomPropertie
## 防御力
@export var def:RandomPropertie


func _ready() -> void:
	$Label.text=name_str
	pass
