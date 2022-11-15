extends Node

var BlackHoles = []
var BlackHoleMass = 100000

var HealthStation

var score = 0
var clock = 0

var PlayerPos = Vector2.ZERO
var PlayerVel = Vector2.ZERO

var play = true

var VP = Vector2.ZERO

func _ready():
	VP = get_viewport().size
	
func _unhandled_input(_event):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
