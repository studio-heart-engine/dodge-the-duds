extends CanvasLayer

signal start_game
signal show_instructions
signal flip_color

func _ready():
	$InstructionLabel.hide()
	$InstructionButton.hide()

func show_message(text, time):
	$MessageLabel.text = text
	$MessageLabel.show()
	
	$MessageTimer.wait_time = time
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over", 3)
	emit_signal("flip_color")
	yield($MessageTimer, "timeout")
	$Name.show()
	yield(get_tree().create_timer(1), 'timeout')
	$StartButton.show()
	#$InstructionButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func _on_StartButton_pressed():
	hide()
	emit_signal("flip_color")
	emit_signal("start_game")

func _on_InstructionButton_pressed():
	hide()
	#$InstructionButton.show()
	emit_signal("show_instructions")

func hide():
	$StartButton.hide()
	$InstructionButton.hide()
	$Name.hide()

