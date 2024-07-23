extends AnimatedSprite2D
@export var maxValue:int=50
var value=0

func _ready():
	$Area2D.body_entered.connect(onBodyEntered)
	var minValue=maxValue-100 if maxValue>100 else 1
	value=randi_range(minValue,maxValue)
func  onBodyEntered(body:Node2D):
	if body.is_in_group("player"):
		var player:Player=body
		player.gold_colected.emit(value)
		queue_free()
		
