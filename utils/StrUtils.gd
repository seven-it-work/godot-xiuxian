extends Node
class_name StrUtils

static func is_blank(s:String)->bool:
	var temp=trim(s);
	if temp==null:
		return true;
	if temp=="":
		return true;
	return false;

static func is_not_blank(s:String)->bool:
	return !is_blank(s);
	
static func trim(s:String):
	if s==null:
		return "";
	return s.trim_prefix(" ").trim_suffix(" ")
