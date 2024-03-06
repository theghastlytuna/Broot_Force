extends Attack

func damaged(args):
	args.from.damage(AttackArguments.new(4,get_parent(),Attack.AttackType.MELEE))
	
