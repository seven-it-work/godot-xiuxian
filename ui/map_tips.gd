extends VBoxContainer

var mapObj

func init(mapObj:MapObj):
	self.mapObj=mapObj
	$Properties/Label.text=mapObj.name_str
	pass


func _on_enter_pressed() -> void:
	var mainNode:MainNode=get_node("/root/Main")
	mainNode.change_tips("",null);
	mainNode.change_core_tscn("MapDetail",mapObj)
	pass # Replace with function body.
