extends PanelContainer

func init() -> void:
	for i in GlobalInfo.place_map.values():
		var btn=preload("res://ui/地图/地图button.tscn").instantiate()
		btn.init(i)
		$GridContainer.add_child(btn)
	pass
