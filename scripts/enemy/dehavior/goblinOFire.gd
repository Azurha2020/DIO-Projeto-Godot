extends Enemy
@onready var attackRange=$Area2D
@export var attackCooldown=1.2
var enemy:Enemy
var sprite2d:AnimatedSprite2D

func _ready():
	enemy=self
	sprite2d=enemy.get_node("CollisionShape2D/AnimatedSprite2D")
	pass
func _process(delta):
	var bodies=attackRange.get_overlapping_bodies()
	if attackRange.has_overlapping_areas():
		for body in bodies:
			if attackCooldown<=0:
				if body.is_in_group("player"):
					sprite2d.play("attack")
					attackCooldown= 1.2
				else:
					sprite2d.play("default")
			else :
				attackCooldown-=delta
	else:
		sprite2d.play("default")
		
			

