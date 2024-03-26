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
	var amountToRoate : float = 0
	
	var toMouseVector = mousePosition - global_position
	var forward = transform.y
	
	var angleToMouse : float = (rad_to_deg(forward.angle_to(toMouseVector)))
	
	amountToRoate = clampi(angleToMouse,-turningAmount,turningAmount)

	#check the raycasts to see if you will hit something
	var checkWallCollision : bool = false
	var leftObject = $CheckLeft.get_collider()
	var rightObject = $CheckRight.get_collider()
	
	if leftObject:
		if leftObject.is_in_group("WALL"):
			checkWallCollision = true
	if rightObject:
		if rightObject.is_in_group("WALL"):
			checkWallCollision = true

	if checkWallCollision:
		amountToRoate = 0
		var leftIntersect : Vector2 = $CheckLeft.get_collision_point()
		var rightIntersect : Vector2 = $CheckRight.get_collision_point()
		
		var leftDistance : float = leftIntersect.distance_to(position)
		var rightDistance : float = rightIntersect.distance_to(position)
		
		if leftDistance < 100 or rightDistance < 100:
			var rotateMultiplier = 1
			if leftDistance > rightDistance:
				rotateMultiplier = -1
			var largestDistance : float = max(leftDistance,rightDistance)
			amountToRoate = turningAwayCurve.sample(largestDistance/100) * turningAwayForce * rotateMultiplier
		
	rotate(deg_to_rad(amountToRoate * (1 + GameManager.getUpgradeAmount("Turning"))))

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
		
	area.HitByRoot(self)
	#area.get_parent().collected()
	area.get_parent().add_to_group("COLLECTED")
	gameSaver.saveGame() #you can remove this, its just here to immediately save your progress
	
func onRootPhaseTimeout():
	currentRootArray.append(global_position)
	EventManager.onRootPhaseEnd.emit()
	pass
