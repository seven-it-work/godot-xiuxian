class_name AllSkill
extends Node
# key=id,value=skill
var all_skill:Dictionary={}

# 注册能
func register(skill:Skill):
	all_skill[skill.id]=skill

func get_skill_by_id(id:String)->Skill:
	var t=all_skill.get(id)
	if !is_instance_valid(t):
		Log.err("没有对应技能id",id)
		return
	return t.duplicate()
