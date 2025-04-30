extends VBoxContainer

var mapObj:MapObj

func init(mapObj:MapObj):
	self.mapObj=mapObj
	initPeopleList()
	pass
	
	
func initPeopleList():
	for i in mapObj.people_dic.values():
		var label=Label.new()
		label.text=i.name_str
		$PeopleList.add_child(label)
	pass
