extends VBoxContainer

func init(place:Place):
	$"名称".text=place.name_str
	$"灵气值".propertie=place.current_lin_qi
	$"生产速度".propertie=place.product_speeding
	$"生产量".propertie=place.product_value
	pass
