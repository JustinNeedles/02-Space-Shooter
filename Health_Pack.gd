extends StaticBody2D

var positionTime = .75
var rotationTime = 10
var baseRot = 8
var recordedTime = 0
var completionPercent = 0.99

var endPosition
var startPosition = Vector2.ZERO
var positionDifference = Vector2.ZERO
var startRotation = 0
var currentRotation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	startPosition = position
	
	startRotation = rand_range(18, 16)
	
	var switch = rand_range(-1, 1)
	
	if switch < 0:
		startRotation = -startRotation
	
	currentRotation = startRotation - ptop(0, startRotation, rotationTime)

func _physics_process(delta):
	positionDifference = (endPosition - startPosition)
	
	position = startPosition + ptop(0, positionDifference.length(), positionTime) * positionDifference.normalized()
	
	if abs(currentRotation) > baseRot:
		currentRotation = startRotation - ptop(0, startRotation, rotationTime)
	else:
		currentRotation = baseRot * startRotation / abs(startRotation)
	
	rotation_degrees += currentRotation
	
	recordedTime += delta

func ptop(start, end, time):
	var difference = end - start
	
	var modifyer = (log(1 + completionPercent) - log(1 - completionPercent)) / time
	
	var thing = 2 / (1 + exp(-modifyer * recordedTime)) - 1
	
	return difference * thing
	

func _on_Area2D_body_entered(body):
	if body.has_method("restore"):
		body.restore(33)
	
	if not "Health" in body.name:
		queue_free()
