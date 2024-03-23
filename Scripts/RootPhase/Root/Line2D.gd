extends Node2D

var distanceFromLastPoint : float = 0
@export var speed : float = 100
var lastPosition : Vector2 = Vector2(0,0)
var time : float = 0
var tipPoints : int = 13
var currentLayerMultiplier : float = 1
var stopMoving :bool = false

@export var lineRenderer : Line2D
@export var tip : Line2D
@export var spawner : Node2D
var lastSpawnedDepth : float = 0
@export var spawnInterval : float #every spawnDepthMod units downward, we spawn a new object
@export var playerCamera : Camera2D
@export var gameSaver : Node2D
@export var turningAwayCurve : Curve
@export var turningAwayForce : float
@export var rootPhaseTimeout : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tip.add_point(Vector2(0,0))
	tip.add_point(Vector2(0,0))
	EventManager.rootStartMoving.connect(setStopMoving.bind(false))
	EventManager.rootStopMoving.connect(setStopMoving.bind(true))
	EventManager.onRootPhaseStart.connect(startRootPhase)
	
func startRootPhase():
	$Timer.wait_time = rootPhaseTimeout
	$Timer.start()

func setStopMoving(b : bool):
	stopMoving = b

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stopMoving:
		return
	#spawn an object every spawnInterval pixels, if you go back up, it will not trigger
	if global_position.y > lastSpawnedDepth + spawnInterval:
		lastSpawnedDepth = snappedi(global_position.y ,spawnInterval)
		spawner.spawnObject(lastSpawnedDepth + playerCamera.get_viewport_rect().size.y)

	position += transform.y * speed * delta * currentLayerMultiplier
	distanceFromLastPoint += position.distance_to(lastPosition)
	lastPosition = position
	var input_dir := Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
	var amountToRoate : float = 0
	
	if input_dir:
		amountToRoate = input_dir.x
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
		
		Debug.Log(leftIntersect," ",rightIntersect)
	
	
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
	area.HitByRoot(self)
	#area.get_parent().collected()
	area.get_parent().add_to_group("COLLECTED")
	gameSaver.saveGame() #you can remove this, its just here to immediately save your progress
	
func onRootPhaseTimeout():
	EventManager.onRootPhaseEnd.emit()
	pass
