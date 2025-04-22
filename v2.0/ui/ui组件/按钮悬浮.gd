extends Button


func _on_gui_input(event: InputEvent) -> void:
	$Window/Label.text="_on_gui_input:%s"%event.get_class()
	if $Window.visible:
		$Window.visible=false
		return
	if event is InputEventScreenTouch:
		# 触摸开始/结束
		if event.pressed:
			$Window.visible=true
			return
	if event is InputEventMouseButton:
		$Window.visible=true
		return
	$Window.visible=false
	pass # Replace with function body.

func _unhandled_key_input(event: InputEvent) -> void:
	$Window/Label.text="_unhandled_key_input:%s"%event.get_class()
	if event is InputEventKey:
		if event.pressed:
			print("按键：", event.keycode)
			$Window.visible=false

func _unhandled_input(event: InputEvent) -> void:
	$Window/Label.text="_unhandled_input:%s"%event.get_class()
	if event is InputEventKey:
		if event.pressed:
			print("按键：", event.keycode)
			$Window.visible=false
	elif event is InputEventMouseButton:
		print("鼠标：", event.position)
		$Window.visible=false
	elif event is InputEventScreenTouch:
		$Window.visible=false
		return

func _on_pressed() -> void:
	$Window.visible=true
	pass # Replace with function body.
