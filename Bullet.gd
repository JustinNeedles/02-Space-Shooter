extends StaticBody2D


var damage = 1
var speed = 1000
var duration = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = duration
	$Timer.start()


func _physics_process(delta):
	position += Vector2(sin(rotation), -cos(rotation)) * speed * delta


func _on_Area2D_body_entered(body):
	if not "Player" in body.name and not "Bullet" in body.name and not "Blast" in body.name:
		if body.has_method("damage"):
			body.damage(damage)
		queue_free()


func _on_Timer_timeout():
	queue_free()
