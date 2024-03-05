extends Node

var rootNode : Node3D

func DrawArrow(start : Vector3, end : Vector3):
	var arrow : Resource = load("res://DEBUG/arrow.tscn")
	var newNode : Node3D = arrow.instantiate()
	rootNode.add_child(newNode)
	newNode.global_position = start
	#newNode.scale.z = (start.distance_to(end))
	newNode.look_at(end)
	
	pass

func Log(a,b = null,c = null,d = null,e = null,f = null,g = null,h = null,i = null,j = null):
	var outputArray : Array
	outputArray.append(a)
	if b == null:
		output(outputArray)
		return
	outputArray.append(b)
	if c == null:
		output(outputArray)
		return
	outputArray.append(c)
	if d == null:
		output(outputArray)
		return
	outputArray.append(d)
	if e == null:
		output(outputArray)
		return
	outputArray.append(e)
	if f == null:
		output(outputArray)
		return
	outputArray.append(f)
	if g == null:
		output(outputArray)
		return
	outputArray.append(g)
	if h == null:
		output(outputArray)
		return
	outputArray.append(h)
	if i == null:
		output(outputArray)
		return
	outputArray.append(i)
	if j == null:
		output(outputArray)
		return
	outputArray.append(j)
	output(outputArray)
	
func LogSpace(a,b = null,c = null,d = null,e = null,f = null,g = null,h = null,i = null,j = null):
	var outputArray : Array
	outputArray.append(a)
	if b == null:
		output(outputArray)
		return
	outputArray.append(" ")
	outputArray.append(b)
	if c == null:
		output(outputArray)
		return
	outputArray.append(" ")
	outputArray.append(c)
	if d == null:
		output(outputArray)
		return
	outputArray.append(" ")
	outputArray.append(d)
	if e == null:
		output(outputArray)
		return
	outputArray.append(" ")
	outputArray.append(e)
	if f == null:
		output(outputArray)
		return
	outputArray.append(" ")
	outputArray.append(f)
	if g == null:
		output(outputArray)
		return
	outputArray.append(" ")
	outputArray.append(g)
	if h == null:
		output(outputArray)
		return
	outputArray.append(" ")
	outputArray.append(h)
	if i == null:
		output(outputArray)
		return
	outputArray.append(" ")
	outputArray.append(i)
	if j == null:
		output(outputArray)
		return
	outputArray.append(" ")
	outputArray.append(j)
	output(outputArray)
	
func output(items : Array):
	var outputString : String = "[b]"
	for i in items:
		outputString += str(i)
	outputString+= "[/b]"
	var stack : String = "		[color=#2e333a]"
	var indexesToSkip : int = 2
	var currentIndex : int = 0
	for i in get_stack():
		currentIndex += 1
		if currentIndex < indexesToSkip+1:
			continue
		var sourceString : String = str(i["source"]).split("/")[-1]
		
		stack += str(sourceString + " " + str(i["function"]) + ":" + str(i["line"])) 
		if currentIndex != get_stack().size():
			stack += " < "
	stack += "[/color]"
	print_rich(outputString + stack)
