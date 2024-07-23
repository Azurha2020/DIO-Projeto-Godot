extends Node
var timer:float=0
@export var initialSpawnRate:float=20
@export var mobspawner:MobSpawner
@export var waveDuration=20
@export var mobIncrement:float=30
@export var breakIntensity:float=0.5
func _process(delta):
	#parar ao game over
	if GameManager.is_gameOver:return
	timer+=delta
	#dificuldade linear
	var currentDifficulty=initialSpawnRate+(mobIncrement*timer/60)
	#sistema de waves
	var sin_wave=sin((timer*TAU)/waveDuration)
	var waveFactor=remap(sin_wave,-1,1,breakIntensity,1)
	currentDifficulty*=waveFactor
	mobspawner.mobs_per_minute=currentDifficulty
	
	pass
