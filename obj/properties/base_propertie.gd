## 基础属性
@tool
extends Node
class_name BasePropertie

## 属性名称
@export var name_str:String=""

## 当前值
@export var current:float=0;

func _get_type()->String:
	return "BasePropertie"

func merge(other:Dictionary)->Dictionary:
	var re:Dictionary=save_json()
	re.set("current",other.get("current",0)+re.get("current",0))
	return re

func save_json():
	var re:Dictionary={}
	re.merge({
		"filename" : get_script().resource_path,
		"name_str":self.name_str,
		"current":self.current,
		"type_info":self._get_type()
	},true)
	return re
	
func load_json(json:Dictionary):
	name_str=json["name_str"]
	current=json["current"]
	

## 获取当前值（可以被子类重写）
func get_current()->float:
	return current


func add_current(v:float):
	current+=v;
