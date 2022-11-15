extends Node2D

var parts = 20

var health = 100

var respawnTimer = 30

var clock = 0

var dying = false

onready var centipedePart = load("res://Centipede_Part.tscn")
onready var centipedeHead = load("res://Centipede_Head.tscn")

var spawn = Vector2(-100, 300)

var death = false

func damage(d):
	health -= d

func death():
	var alternate = sin($Timer.time_left * 3 * PI)
	if alternate <= 0.5 and dying:
		for i in get_children():
			if i.name != "Timer":
				i.visible = false
	elif dying:
		for i in get_children():
			if i.name != "Timer":
				i.visible = true
	if $Timer.time_left <= 0 and dying:
		dying = false
		for i in get_children():
			if i.name != "Timer":
				i.position = spawn
				i.visible = true
		
# Called when the node enters the scene tree for the first time.
func _ready():
	var holdFollow = centipedeHead.instance()
	add_child(holdFollow)
	holdFollow.position = spawn
	
	for _i in range(parts):
		var part = centipedePart.instance()
		part.follow = holdFollow
		holdFollow = part
		add_child(holdFollow)
		holdFollow.position = spawn
	birth()

func birth():
	health = 100
	death = false
	clock = 0
	for i in get_children():
		if i.name != "Timer":
			if i.get_node("Area2D/CollisionPolygon2D").disabled == true:
					i.get_node("Area2D/CollisionPolygon2D").disabled = false

func _physics_process(delta):
	if death:
		clock += delta
		if not dying:
			var x = 0
			for i in get_children():
				if i.name != "Timer":
					x += 1
					if (respawnTimer - 3.0) / 21.0 * x <= clock - 3 and i.get_node("Area2D/CollisionPolygon2D").disabled == true:
						i.get_node("Area2D/CollisionPolygon2D").disabled = false
	
	if clock >= respawnTimer:
		birth()
	
	if health <= 0 or not Global.play:
		if not death:
			dying = true
			if Global.play:
				Global.score += 1000
			$Timer.start()
			death = true
			for i in get_children():
				if i.name != "Timer":
					i.get_node("Area2D/CollisionPolygon2D").disabled = true
		death()
