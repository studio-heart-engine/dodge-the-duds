extends CanvasLayer

signal start_game
signal flip_color

func _ready():
	$InstructionLabel.hide()


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
	$InstructionButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func _on_StartButton_pressed():
	hide()
	$ScoreLabel.show()
	emit_signal("flip_color")
	emit_signal("start_game")

func _on_InstructionButton_pressed():
	if ($InstructionButton.text == "Instructions"):
		hide()
		$InstructionButton.show()
		$InstructionButton.text = "Back"
		$InstructionLabel.show()
	else:
		$Name.show()
		$StartButton.show()
		$InstructionLabel.hide()
		$ScoreLabel.show()
		$InstructionButton.text = "Instructions"

func hide():
	$StartButton.hide()
	$InstructionButton.hide()
	$ScoreLabel.hide()
	$Name.hide()

