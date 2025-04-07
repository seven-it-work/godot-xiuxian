extends Button
@export var action_cool_times_callable:Callable
# 字符串备份
var text_bak:String=""

func init(action_cool_times_callable:Callable):
	self.action_cool_times_callable=action_cool_times_callable
	self.text_bak=self.text
	pass

func _ready() -> void:
	self.text_bak=self.text

func _process(delta: float) -> void:
	if GlobalInfo.is_pause:
		return
	if !action_cool_times_callable:
		return
	if action_cool_times_callable.call()>0:
		self.disabled=true
		self.text=self.text_bak+"（剩余%.0f秒）"%action_cool_times_callable.call()
	else:
		if self.disabled:
			self.disabled=false
			self.text=self.text_bak
	pass
