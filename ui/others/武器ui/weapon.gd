extends PanelContainer

var weapon:Weapon

func _ready() -> void:
	$Label.text="空"
	pass

func init(weapon:Weapon):
	$Label.text="空"
	if weapon:
		self.weapon=weapon
		$Label.text=weapon.name_str
	pass

func  _get_tooltip(at_position: Vector2):
	if self.weapon:
		# 可以显示tooltip
		return " "
	# 不显示tooltip
	return ""

func _make_custom_tooltip(for_text):
	if self.weapon:
		var ui=preload("res://ui/others/武器ui/武器tooltipui.tscn").instantiate()
		ui.init(self.weapon)
		return ui
	return null
