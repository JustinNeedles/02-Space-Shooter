extends VSlider


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var offset = Vector2(10, -80)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var player = get_parent().get_node("Player")
	
	if player != null:
		rect_position = player.position + offset
