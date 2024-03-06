extends Resource
class_name AttackArguments

#made the attack arguments into a class cause we can add different parameters for attacking in the future, and this way we dont have to change signals all the time
#this class just gives us more flexibility when we have to balance later
#this also lets the classes that inherit attack change the values before they are applied (such as reducing the attack amount)

var attackDamage : float
var attackType : Attack.AttackType
var from : Node2D

func _init(amount, attacker, type) -> void:
	attackDamage = amount
	attackType = type
	from = attacker
