extends KinematicBody2D

var velocity = Vector2.ZERO

var shooting = false

var rotation_speed = .75
var acceleration = 4.0
var lowAcceleration = 12.0
var deceleration = 0.4
var soft_max_velocity = 120
var hard_max_velocity = 300
var health = 1

var shotSpread = 5
var shotWait = 3
var shotWaitCount = 0

var fuel = 100

var burnAccel = 1

var boostTime = .5
var boost = false

var death = false

onready var Blast = load("res://Blast.tscn")

onready var shoot = load("res://Bullet.tscn")

func _physics_process(delta):
	
	if health < 0:
		if not death:
			get_parent().get_node("VSlider").queue_free()
			$Timer.start()
			death = true
			$CollisionPolygon2D.disabled = true
			$Area2D.monitorable = false
			$Area2D.monitoring = false
			Global.play = false
		death()
	else:
		get_input()
		
		if shooting:
			rotation_speed = 0.75
			fuel -= 2 * delta
		elif boost:
			rotation_speed = 1.3
		else:
			rotation_speed = 2
		
		if boost:
			var blast = Blast.instance()
			blast.position += Vector2(0, 50)
			add_child(blast)
			velocity += Vector2.UP.rotated(rotation) * acceleration
			fuel -= 10 * delta
		
		if velocity.length() > soft_max_velocity:
			var wait = velocity.normalized() * deceleration * (velocity.length() - soft_max_velocity / 2) / (soft_max_velocity * 2)
			if (velocity - wait).length() < soft_max_velocity:
				velocity = soft_max_velocity * velocity.normalized()
			else:
				velocity -= wait
		
		if velocity.length() > hard_max_velocity:
			velocity = velocity.normalized() * hard_max_velocity
		
		velocity = velocity + displace()
		
		position += velocity * delta
		
		get_parent().get_node("VSlider").value = fuel
		
		if position.x > Global.VP.x:
			position.x = Global.VP.x
			velocity.x = 0
			damage(100)
		elif position.x < 0:
			position.x = 0
			velocity.x = 0
			damage(100)
		
		if position.y > Global.VP.y:
			position.y = Global.VP.y
			velocity.y = 0
			damage(100)
		elif position.y < 0:
			position.y = 0
			velocity.y = 0
			damage(100)
			
		Global.PlayerPos = position
		Global.PlayerVel = velocity

func death():
	var alternate = sin($Timer.time_left * 3 * PI)
	if alternate <= 0.5:
		visible = false
	else:
		visible = true
	
	if $Timer.time_left <= 0:
		get_tree().change_scene("res://End Screen.tscn")
		queue_free()
	

func get_input():
	shooting = false
	if Input.is_action_pressed("left"):
		rotation_degrees = rotation_degrees - rotation_speed
	if Input.is_action_pressed("right"):
		rotation_degrees = rotation_degrees + rotation_speed
	if Input.is_action_pressed("Space") and fuel > 0:
		boost = true
	else:
		boost = false
	if Input.is_action_pressed("Blast") and fuel > 0:
		shooting = true
		shotWaitCount += 1
		if shotWaitCount >= shotWait:
			var effects = get_node("/root/Game/Effects")
			var bullet = shoot.instance()
			var randomRot = rand_range(-shotSpread, shotSpread)
			effects.add_child(bullet)
			bullet.rotation_degrees = rotation_degrees + randomRot
			bullet.position = position + Vector2(sin(rotation), -cos(rotation)) * 10
			shotWaitCount = 0
	if Input.is_action_pressed("Burn_Right"):
		var blast = Blast.instance()
		blast.position += Vector2(25, 10)
		blast.scale = Vector2(.5, .5)
		add_child(blast)
		velocity += Vector2(-1, 0).normalized().rotated(rotation) * burnAccel
	if Input.is_action_pressed("Burn_Left"):
		var blast = Blast.instance()
		blast.position += Vector2(-25, 10)
		blast.scale = Vector2(.5, .5)
		add_child(blast)
		velocity += Vector2(1, 0).normalized().rotated(rotation) * burnAccel

func damage(d):
	health -= d

func restore(d):
	fuel += d
	if fuel > 100:
		fuel = 100

func displace():
	var displacement = Vector2.ZERO
	for i in Global.BlackHoles:
		var dH = Vector2(i.x - position.x, i.y - position.y)
		displacement += dH.normalized() * Global.BlackHoleMass / pow(dH.length(), 2)
		
	var dH = Global.HealthStation - position
	var dis = dH.normalized() * 50000 / pow(dH.length(), 2)
		
	if dis.length() > 4:
		displacement += dH.normalized() * 4
	else:
		displacement += dis

	
	return displacement

func _on_Area2D_body_entered(body):
	if body.name != "Player" and not "Blast" in body.name and not "Health_Pack" in body.name and not "Bullet" in body.name:
		damage(100)
