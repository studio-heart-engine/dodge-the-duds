extends Area2D

signal hit

export var speed = 400
var screen_size

var accelarationX = 0
var accelarationY = 0

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if (accelarationX != 0):
		accelarationX += -1 * (min(5, abs(accelarationX))) * accelarationX / abs(accelarationX)
	if (accelarationY != 0):
		accelarationY += -1 * (min(5, abs(accelarationY))) * accelarationY / abs(accelarationY)
	if (Input.is_action_pressed("ui_right")):
			#velocity.x += 1
			if (accelarationX == 0):
				accelarationX += 13
			else:
				accelarationX += 7
	if (Input.is_action_pressed("ui_left")):
			#velocity.x -= 1
			if (accelarationX == 0):
				accelarationX -= 13
			else:
				accelarationX -= 7
	if (Input.is_action_pressed("ui_up")):
			#velocity.y -= 1
			if (accelarationY == 0):
				accelarationY -= 13
			else:
				accelarationY -= 7
	if (Input.is_action_pressed("ui_down")):
			#velocity.y += 1
			if (accelarationY == 0):
				accelarationY += 13
			else:
				accelarationY += 7
	velocity.x += accelarationX
	velocity.y += accelarationY
	if (velocity.length() > 0):
		#velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if (velocity.x != 0):
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = (velocity.x < 0)
	elif (velocity.y != 0):
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.flip_v = (velocity.y > 0)

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
