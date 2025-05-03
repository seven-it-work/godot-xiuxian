extends Button

func _update(winNode:Node):
	for i in $Window.get_children():
		i.queue_free()
	$Window.add_child(winNode.duplicate())
	pass

func _on_button_down() -> void:
	$Window.visible=true
	pass # Replace with function body.


func _on_button_up() -> void:
	$Window.visible=false
	pass # Replace with function body.
