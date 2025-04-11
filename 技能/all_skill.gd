class_name AllSkill
extends Node
# key=id,value=skill
var all_skill:Dictionary={}

# 注册能
func register(skill:Skill):
	all_skill[skill.id]=skill

func get_skill_by_id(id:String)->Skill:
	return all_skill.get(id)
