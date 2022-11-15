extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	$Score.text = "Score: " + str(Global.score)
	$Wave.text = "Time: " + str(Global.clock)
