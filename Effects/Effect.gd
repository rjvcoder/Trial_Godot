extends AnimatedSprite

func _ready():
	#connect(signal,who owns function,function to call
	connect("animation_finished",self,"_on_animation_finished")
	frame = 0 #start on first frame
	play("Animate")

func _on_animation_finished():
	queue_free() #destroy self
