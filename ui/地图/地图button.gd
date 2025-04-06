extends PanelContainer

var place:Place

func init(place:Place):
	self.place=place
	$VBoxContainer/Button.text=place.name_str
	$VBoxContainer/RichTextLabel.text=place.description
	$VBoxContainer/Button.pressed.connect(show_detail.bind(place))
	
func show_detail(place:Place):
	GlobalInfo.main_node.change_tips("地图点击tips",place)
	pass
