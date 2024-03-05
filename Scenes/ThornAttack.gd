extends Attack

func onDamaged(args : AttackArguments):
	args.from.damage(AttackArguments.new(4,get_parent(),Attack.AttackType.MEELE))
	pass
	
	
