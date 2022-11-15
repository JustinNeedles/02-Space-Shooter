extends Node2D

var speed = 200

var oscilationMagnitude = 100
var oscilationFrequency = .3333

var velocity = Vector2.ZERO

func _physics_process(delta):
	if get_parent().death != true:
		var temp = Vector2(Global.PlayerPos.x - position.x, Global.PlayerPos.y - position.y).normalized()
		
		var perp = Vector2(temp.y, -temp.x)
		
		velocity = temp * speed + perp * oscilationMagnitude * sin($Timer.time_left * oscilationFrequency * PI)
		
		position += velocity * delta

func damage(d):
	get_parent().damage(d)

func _on_Area2D_body_entered(body):
	if "Bullet" in body.name and not get_parent().death:
		damage(1)
		body.queue_free()
	
	if not "Centipede" in body.name:
		if body.has_method("damage"):
			body.damage(100)
