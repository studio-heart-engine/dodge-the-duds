extends AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_start_poof(position):
	self.position = position
	self.show()
	self.play()
	yield(get_tree().create_timer(.8), "timeout")
	self.hide()
	self.stop()
