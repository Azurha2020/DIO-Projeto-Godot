class_name MobSpawner
extends Node2D
@onready var pathFollow2D:PathFollow2D=%PathFollow2D
@export var creatures: Array[PackedScene]
@export var mobs_per_minute:float=30
var cooldown:float=1.0
func getPoint()->Vector2:
	pathFollow2D.progress_ratio=randf()
	return pathFollow2D.global_position
	
func _process(delta):
	#parar ao game over
	if GameManager.is_gameOver:return
	#temporizador (cooldown)
	cooldown-=delta
	if cooldown>=0:
		return
	
	
	#instaciar criatura aleatoria
	##pegar criatura aletatoria
	var index=randi_range(0,creatures.size()-1)
	var creatureScene=creatures[index]
	##pegar ponto aleatório
	var point=getPoint()
	##Checa se o ponto é valido
	var world_state=get_world_2d().direct_space_state
	var parameters=PhysicsPointQueryParameters2D.new()
	parameters.position=point
	parameters.collision_mask=0b1000
	var result=world_state.intersect_point(parameters,1)
	if not result.is_empty():
		return
	##intanciar criatura
	var creature=creatureScene.instantiate()
	##Colocar na posição
	creature.global_position=point
	get_parent().add_child(creature)
	#frequencia monstros/minuto
	var inteval=60.0/mobs_per_minute
	cooldown=inteval
	pass
