extends Area2D

signal hit
signal start_poof
signal end_poof

export var speed = 400
var screen_size

var accelarationX = 0
var accelarationY = 0

var can_blink = true
var hidden = false
var dead = false

func start(pos):
	dead = false
	accelarationX = 0
	accelarationY = 0
	var velocity = Vector2()
	velocity.x = 0
	velocity.y = 0
	position = pos
	$Player.animation = "right"
	$Player.flip_h = false
	$Player.flip_v = false
	$Player.play()
	show()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (hidden || dead):
		return
	var velocity = Vector2()
	if (accelarationX != 0):
		accelarationX += -1 * (min(5, abs(accelarationX))) * accelarationX / abs(accelarationX)
	if (accelarationY != 0):
		accelarationY += -1 * (min(5, abs(accelarationY))) * accelarationY / abs(accelarationY)
	var changeX = 0
	var changeY = 0
	if (Input.is_action_pressed("ui_right")):
		changeX += 7
	if (Input.is_action_pressed("ui_left")):
		changeX -= 7
	if (Input.is_action_pressed("ui_up")):
		changeY -= 7
	if (Input.is_action_pressed("ui_down")):
		changeY += 7
	
	if (Input.is_action_pressed("blink")):
		if ((changeX != 0 || changeY != 0) && can_blink):
			emit_signal("start_poof", position)
			hide()
			position.x += changeX * 24
			position.y += changeY * 24
			yield(get_tree().create_timer(.5), "timeout")
			emit_signal("end_poof", position)
			show()
			position.x = clamp(position.x, 0, screen_size.x)
			position.y = clamp(position.y, 0, screen_size.y)
			can_blink = false
			$BlinkTimer.start()
	
	accelarationX += changeX
	accelarationY += changeY
	velocity.x += accelarationX
	velocity.y += accelarationY
	
	if (velocity.length() > 0):
		$Player.play()
	else:
		$Player.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if (changeX != 0):
		$Player.animation = "right"
		$Player.flip_h = (changeX <= 0)
	elif (changeY != 0):
		$Player.animation = "up"
		$Player.flip_v = (changeY >= 0)

func hide():
	$Player.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	hidden = true

func show():
	$Player.show()
	$CollisionShape2D.set_deferred("disabled", false)
	hidden = false

func _on_Player_body_entered(body):
	$CollisionShape2D.set_deferred("disabled", true)
	dead = true
	$Player.animation = "death"
	$Player.play()
	yield(get_tree().create_timer(2), "timeout")
	hide()
	emit_signal("hit")

func _on_BlinkTimer_timeout():
	can_blink = true
