extends Node2D

var timeStart

var newTimer = 0

onready var Enemy = load("res://Enemy.tscn")
onready var Enemy20 = load("res://Enemy20.tscn")
var maxEnemies = 10
var maxEnemies20 = 3

var spawn20s = true

var rng = RandomNumberGenerator.new()

var time = false

onready var clock = get_child(0)
var spacer = 2

func _ready():
	timeStart = Time.get_unix_time_from_system() 
	clock.wait_time = spacer
	clock.start()

func _physics_process(delta):
	if Global.play:
		newTimer += delta
	
	Global.clock = round(newTimer)
	
	spacer = 1.5 / (1 + newTimer/10) + .5
	
	var children = get_children()
	
	var enemyCount = 0
	var enemy20Count = 0
	
	var oldEnemy
	
	for i in children:
		if "Enemy20" in i.name:
			enemy20Count += 1
		elif "Enemy" in i.name:
			if enemyCount <= 0:
				oldEnemy = i
			enemyCount += 1
			if enemyCount > maxEnemies:
				oldEnemy.queue_free()
	
	if enemy20Count >= maxEnemies20:
		spawn20s = false
	else:
		spawn20s = true
	
	if time:
		rng.randomize()
		var choice = rng.randf_range(0, 10)
		
		var enemy = null
		
		if Global.play:
			if choice > 9 and spawn20s:
				enemy = Enemy20.instance()
			else:
				enemy = Enemy.instance()
		
			var xRand = 0
			var yRand = 0
			
			var choice2 = rng.randi_range(0, 3)
			
			if choice2 == 0:
				xRand = -100
				yRand = rng.randi_range(-100, Global.VP.y + 100)
			elif choice2 == 1:
				xRand = Global.VP.x + 100
				yRand = rng.randi_range(-100, Global.VP.y + 100)
			elif choice2 == 2:
				xRand = rng.randi_range(-100, Global.VP.x + 100)
				yRand = -100
			else:
				xRand = rng.randi_range(-100, Global.VP.y + 100)
				yRand = Global.VP.y + 100
				
			enemy.position = Vector2(xRand, yRand)
			add_child(enemy)
			time = false
			clock.wait_time = spacer
			clock.start()

func _on_Timer_timeout():
	time = true
