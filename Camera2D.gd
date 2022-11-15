extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()


func _physics_process(delta):
	var this = get_parent().get_node("Player")
	if this != null:
		position = this.position
