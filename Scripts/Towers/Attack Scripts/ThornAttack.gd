extends Attack

func damaged(args):
	pass
	##We might bring this back later when we actually have ranged units
	#if args.attackType != AttackType.RANGED:
	args.from.damage(AttackArguments.new(4,get_parent(),Attack.AttackType.MELEE))
	
