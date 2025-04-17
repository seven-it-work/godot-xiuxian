extends Equipment
class_name Weapon

func get_type()->String:
	return "Weapon"

func get_excel_original_data():
	return Settings.Weapon


func _属性设置(excelData:Dictionary):
	var baseData=get_excel_original_data().data.get(0).duplicate(true)
	_merged(excelData,baseData,"生命值",{})
	_merged(excelData,baseData,"攻击力",{})
	_merged(excelData,baseData,"防御力",{})
	_merged(excelData,baseData,"装备条件",[])
	super._属性设置(excelData)
