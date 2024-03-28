extends Node2D

var distanceFromLastPoint : float = 0

var lastPosition : Vector2 = Vector2(0,0)
var time : float = 0
var tipPoints : int = 13
var currentLayerMultiplier : float = 1
var stopMoving :bool = false

const waterSound: AudioStream =  preload("res://Sounds/SFX/water.mp3")
const dirtSound: AudioStream =  preload("res://Sounds/SFX/dirt.mp3")
const crackSound: AudioStream =  preload("res://Sounds/SFX/crack.mp3")

const music: AudioStream =  preload("res://Sounds/Music/KiloWatts - Gollum Fingers.mp3")

@export_category("Root Movement")
@export var speed : float = 100
@export var turningAmount : float
@export_category("Wall collisions")
@export var wallNode : Node2D
@export var turningAwayCurve : Curve
@export var turningAwayForce : float
@export var cast : RayCast2D
@export var debugCast : RayCast2D
@export var wallMargin : float = 50
@export_category("Root creation")
@export var lineRenderer : Line2D
@export var tip : Line2D
@export var playerCamera : Camera2D
@export_category("Spawning & Saving")
@export var spawner : Node2D
@export var spawnInterval : float #every spawnDepthMod units downward, we spawn a new object
@export var gameSaver : Node2D
@export var rootPointSaveArcLength : float = 200
@export_category("Root Phase Variables")
@export var rootPhaseTimeout : float

var lastSpawnedDepth : float = 0
var mousePosition = Vector2.ZERO
var currentRootArray : Array
var spawningArcLength : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turningAmount = turningAmount * (1 + GameManager.getUpgradeAmount("Turning"))
	tip.add_point(Vector2(0,0))
	tip.add_point(Vector2(0,0))
	
	SoundManager.set_default_ambient_sound_bus("Ambient")
	SoundManager.set_default_sound_bus("Effects")
	SoundManager.set_default_music_bus("Music")
	
	SoundManager.play_ambient_sound(dirtSound)
	SoundManager.play_music(music)
	EventManager.rootStartMoving.connect(setStopMoving.bind(false))
	EventManager.rootStopMoving.connect(setStopMoving.bind(true))
	EventManager.onRootPhaseStart.connect(startRootPhase)
	
func startRootPhase():
	GameManager.pastRoots[(GameManager.currentRootRound)] = []
	currentRootArray = GameManager.pastRoots[(GameManager.currentRootRound)]
	currentRootArray.append(Vector2.ZERO)
	$Timer.wait_time = rootPhaseTimeout * (1 + GameManager.getUpgradeAmount("Duration"))
	$Timer.start()

func setStopMoving(b : bool):
	stopMoving = b

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stopMoving:
		return
		
	wallNode.global_position.y = global_position.y
	#spawn an object every spawnInterval pixels, if you go back up, it will not trigger
	if global_position.y > lastSpawnedDepth + spawnInterval:
		lastSpawnedDepth = snappedi(global_position.y ,spawnInterval)
		spawner.spawnObject(lastSpawnedDepth + playerCamera.get_viewport_rect().size.y)

#Start with the forward vector, apply speed account for root upgrased, apply delta, 
#then apply the current layer's slowdown
	position += transform.y * (speed * (1 + GameManager.getUpgradeAmount("Speed"))) * delta * currentLayerMultiplier
	var distanceFromLast = position.distance_to(lastPosition)
	distanceFromLastPoint += distanceFromLast
	spawningArcLength += distanceFromLast
	lastPosition = position
	
	if spawningArcLength >= rootPointSaveArcLength:
		spawningArcLength = 0	
		currentRootArray.append(global_position)
	
	mousePosition = get_global_mouse_position()
	cast.target_position = mousePosition-position
	if mousePosition.distance_to(global_position) < 200:
		cast.target_position = (mousePosition-position).normalized()*200
	var desiredPosition = mousePosition
	
	#check the raycasts to see if you will hit something
	var checkWallCollision : bool = false
	var forwardObject = cast.get_collider()
	
	
	
	if forwardObject:
		if forwardObject.is_in_group("WALL"):
			checkWallCollision = true

	if checkWallCollision:
		
		var intersect : Vector2 = cast.get_collision_point()		
		var distance : float = intersect.distance_to(position)
	
		if distance < 200:
			
			var upOrDown = -1
			if intersect.y < global_position.y:
				upOrDown = 1
				
			var leftOrRight = 1 #left
			if intersect.x > global_position.x:
				leftOrRight = -1
			desiredPosition = intersect + Vector2(leftOrRight*wallMargin,(upOrDown*wallMargin) + (min(intersect.length(),200)*-upOrDown))
			debugCast.target_position = desiredPosition
			
			#Debug.Log(desiredPosition)
			


	var amountToRoate : float = 0
	
	var desiredVector = desiredPosition - global_position
	var forward = transform.y
	
	var amountToTurn = turningAmount 
	var angleToMouse : float = (rad_to_deg(forward.angle_to(desiredVector)))
	
	amountToRoate = clampi(angleToMouse,-amountToTurn,amountToTurn)
	Debug.Log(amountToRoate)
	rotate(deg_to_rad(amountToRoate))

	var size : int = tip.points.size()-1
	tip.points[size] = position
	if distanceFromLastPoint >= 25:
		tip.add_point(position)
		if size >= tipPoints:			
			tip.remove_point(0)
		if size >= tipPoints-1:
			var removingPoint : Vector2 = tip.points[0]
			lineRenderer.add_point(removingPoint)
				
		distanceFromLastPoint = 0
		

func _on_background_manager_changed_layer(layerSpeedMultiplier):
	currentLayerMultiplier = layerSpeedMultiplier

func _on_area_entered(area):
	if area.get_parent().is_in_group("COLLECTED"):
		return
		
	if area.get_parent().is_in_group("WaterResources"):
		SoundManager.play_sound(waterSound)
	elif area.get_parent().is_in_group("UnitRemains"):
		SoundManager.play_sound(crackSound)
	elif area.get_parent().is_in_group("Obstacles"):
		SoundManager.stop_ambient_sound(dirtSound)
		
	if area.has_method("HitByRoot"):
		area.HitByRoot(self)
	#area.get_parent().collected()
	area.get_parent().add_to_group("COLLECTED")

	
func onRootPhaseTimeout():
	currentRootArray.append(global_position)
	EventManager.onRootPhaseEnd.emit()
	pass
