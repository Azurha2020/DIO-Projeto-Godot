extends Node

@export var speed:float=0.5

var enemy:Enemy
var sprite2d


func _ready():
	enemy=get_parent()
	sprite2d=enemy.get_node("CollisionShape2D/AnimatedSprite2D")
	pass
func _physics_process(delta):
	#parar ao game over
	if GameManager.is_gameOver:return
	var playerPosition=GameManager.playerPosition
	var difference=playerPosition-enemy.position
	var inputVector=difference.normalized()
	enemy.velocity=inputVector*speed/delta
	if inputVector.x>0:
		#demarcar flip h
		sprite2d.flip_h =false
		pass
	elif inputVector.x<0:
		#marcar flip h
		sprite2d.flip_h =true
	enemy.move_and_slide()
	
