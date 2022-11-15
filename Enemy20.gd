extends StaticBody2D


var speed = 4
var velocity = Vector2.ZERO

var softCapVel = 100

var health = 4

var death = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if health <= 0 or not Global.play:
		if not death:
			if Global.play:
				Global.score += 20
			$Timer.start()
			death = true
			$CollisionPolygon2D.disabled = true
			$Area2D.monitorable = false
			$Area2D.monitoring = false
		death()
	else:
		var temp = Vector2(Global.PlayerPos.x - position.x, Global.PlayerPos.y - position.y)
		
		var movement = temp.normalized() * speed
		
		velocity = movement + velocity + displace()
		
		if velocity.length() > softCapVel:
			var wait = velocity.normalized() * (velocity.length() - softCapVel / 2) / (softCapVel * 2)
			if (velocity - wait).length() < softCapVel:
				velocity = softCapVel * velocity.normalized()
			else:
				velocity -= wait
		
		position += velocity * delta

func death():
	var alternate = sin($Timer.time_left * 3 * PI)
	if alternate <= 0.5:
		visible = false
	else:
		visible = true
	if $Timer.time_left <= 0:
		queue_free()

func damage(d):
	health -= d

func displace():
	var displacement = Vector2.ZERO
	for i in Global.BlackHoles:
		var dH = Vector2(i.x - position.x, i.y - position.y)
		displacement += dH.normalized() * Global.BlackHoleMass / pow(dH.length(), 2)
	if displacement.length() > 100:
		displacement = displacement.normalized() * 100
	return displacement


func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		body.damage(100)
		health = 0
	if "Centipede" in body.name or "Black" in body.name or "Station" in body.name or "Blast" in body.name:
		health = 0
