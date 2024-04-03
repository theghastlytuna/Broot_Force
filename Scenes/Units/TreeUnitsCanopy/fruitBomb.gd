extends CharacterBody2D

@export var startingNode : Node2D
@export var targetNode : Node2D
@export var speed : float
@export var bombSprite : Sprite2D
@export var attackNode : Node2D

@export var damage : float

signal BombDetonated

# Called when the node enters the scene tree for the first time.
func _ready():
	attackNode.attackDamage = damage
	bombSprite.visible = false
	position = startingNode.position
	velocity = Vector2.ZERO
	attackNode.enableAttack(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		detonate()

func reset():
	bombSprite.visible = true
	position = startingNode.position
	velocity = (targetNode.position - position).normalized() * speed

func detonate():
	bombSprite.visible = false
	velocity = Vector2.ZERO
	attackNode.enableAttack(true)
	BombDetonated.emit()
