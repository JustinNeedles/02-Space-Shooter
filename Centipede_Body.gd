extends Node2D


var space = 30
var follow

func _physics_process(_delta):
	if get_parent().death != true:
		var difference = Vector2(follow.position.x - position.x, follow.position.y - position.y)
		var direction = difference.normalized()
		
		if difference.length() > space:
			position = Vector2(follow.position.x - direction.x * space, follow.position.y - direction.y * space)

func damage(d):
	get_parent().damage(d)
	

func _on_Area2D_body_entered(body):
	if "Bullet" in body.name and not get_parent().death:
		damage(1)
		body.queue_free()
	
	if not "Centipede" in body.name:
		if body.has_method("damage"):
			body.damage(100)
