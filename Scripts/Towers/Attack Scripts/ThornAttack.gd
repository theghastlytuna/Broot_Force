extends Attack

func damaged(args):
	if args.attackType != AttackType.RANGED:
		args.from.damage(AttackArguments.new(4,get_parent(),Attack.AttackType.MELEE))
	
