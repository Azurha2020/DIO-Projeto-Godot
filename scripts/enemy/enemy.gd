class_name Enemy
extends Node2D
@export var health:int=40	
@export var deathTemplate:PackedScene
@export var baseDamage=5
@export_category("drops")
@export var dropChance:float=0.3
@export var dropItens:Array[PackedScene]
@export var dropChances:Array[float]
var damageIndicationScene: PackedScene=preload("res://UI/damageIndicator.tscn")
@onready var damageDigitMarker=$damageMarker

func damage(amount:int,direction:Vector2):
	#computar dano
	health-=amount
	#por knockback
	knockback(direction)
	# piscar node
	modulate=Color.RED
	var tween=create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
	if damageIndicationScene.can_instantiate():
		var damageIndication=damageIndicationScene.instantiate()
		damageIndication.value=amount
		if damageDigitMarker:
			damageIndication.global_position=damageDigitMarker.global_position
		else:
			damageIndication.global_position=global_position
		get_parent().add_child(damageIndication)
	if health<=0:
		death()
func death():
	
	
	#drops
	if randf()<=dropChance:
		dropItem()
	else :
		#animação de morte
		if deathTemplate:
			var	deathObject=deathTemplate.instantiate()
			deathObject.position=position
			get_parent().add_child(deathObject)
	GameManager.countMonsters+=1
	queue_free()
func knockback(direction:Vector2):
	position+=direction*50
func get_dropItem():
	if dropItens.size()==0:
		return 
	if dropItens.size()==1:
		return dropItens[0]
	#calcular chance total
	var maxChance=0.0
	for drop_chance in dropChances:
		maxChance+=drop_chance
	#jogar dado
	var randomValue=randf()*maxChance
	#escolher item
	var needle=0.0
	for i in dropItens.size():
		var dropItem=dropItens[i]
		var dropPerc=dropChances[i] if i<dropChances.size() else 1
		if randomValue<=dropPerc+needle:
			return dropItem
		needle+=dropPerc
	return dropItens[0]
func dropItem():
	var template=get_dropItem()
	if template!= null:
		var	dropObject=template.instantiate()
		dropObject.position=position	
		get_parent().add_child(dropObject)
