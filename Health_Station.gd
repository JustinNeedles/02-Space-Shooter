extends StaticBody2D

var cooldown = 5

var travelTime = .4

var awake = true

var inRange = false

var rotationSpeed = 180
var rotationPercent = 1

var shotGap = 0.25
var gapTime = 0
var shotCount = 0
var maxCount = 3
var rangeVal = 200

onready var pack = load("res://Health_Pack.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.HealthStation = position
	
	$Timer.wait_time = cooldown

func prediciton():
	var pred = Global.PlayerPos + Global.PlayerVel * travelTime
	return pred

func shoot():
	var thing = pack.instance()
	add_child(thing)
	thing.position = Vector2.ZERO
	thing.endPosition = prediciton() - position
	thing.positionTime = travelTime
	shotCount += 1
	gapTime = 0

func _physics_process(delta):
	gapTime += delta
	
	if inRange and not awake:
		$Timer.paused = true
	elif not awake:
		$Timer.paused = false
	
	if (position - prediciton()).length() <= rangeVal:
		inRange = true
	else:
		inRange = false
	
	if awake:
		if rotationPercent < 1:
			rotationPercent += delta
		else:
			rotationPercent = 1
	else:
		if rotationPercent > 0:
			rotationPercent -= delta
		else:
			rotationPercent = 0
		
	$Area2D.rotation_degrees += rotationSpeed * rotationPercent * delta
	$Sprite.rotation_degrees += rotationSpeed * rotationPercent * delta
	$CollisionPolygon2D.rotation_degrees += rotationSpeed * rotationPercent * delta
	
	if inRange and gapTime >= shotGap and awake:
		shoot()
		
	if shotCount > 0 and not inRange:
		$Timer.start()
		awake = false
		shotCount = 0
		
	if shotCount >= maxCount:
		$Timer.start()
		awake = false
		shotCount = 0


func _on_Timer_timeout():
	awake = true
