extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var body

# Called when the node enters the scene tree for the first time.
func _ready():
	play("default")
	body = get_node("Blast/Area2D")
	body.monitorable = false
	
func _physics_process(_delta):
	if frame >= 2:
		body.monitorable = true
	else:
		body.monitorable = false
		
func _on_AnimatedSprite_animation_finished():
	queue_free()
