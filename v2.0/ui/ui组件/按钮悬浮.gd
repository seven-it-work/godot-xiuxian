extends Button

func _update(winNode:Node):
	for i in $Window.get_children():
		i.queue_free()
	$Window.add_child(winNode.duplicate())
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton || event is InputEventScreenTouch:
		$Window.visible=true
		return

func _on_pressed() -> void:
	$Window.visible=true
	pass # Replace with function body.
