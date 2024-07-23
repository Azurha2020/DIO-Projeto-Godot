extends Node2D
@export var health:int=2000


func _ready():
	$Area2D.body_entered.connect(onBodyEntered)
	
	
func  onBodyEntered(body:Node2D):
	if body.is_in_group("player"):
		var player:Player=body
		player.heal(health)
		player.meat_colected.emit(health)
		queue_free()
		
