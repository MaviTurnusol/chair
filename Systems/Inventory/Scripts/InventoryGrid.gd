extends Resource
class_name InventoryGrid

var InventoryDict : Dictionary[Vector2i,InventoryItem] #Whereandwhat
var ItemsInInv : Array[InventoryItem]
var InventorySize : Vector2

func _init(_size : Vector2i) -> void:
	InventorySize = _size

func UpdateInventoryDict():
	#Set all values to null
	InventoryDict.clear()
	for y in range(0,InventorySize.y):
		for x in range(0,InventorySize.x):
			InventoryDict[Vector2i(x,y)] = null
	
	#Construct fromn Inv
	#print("AM I DONE")
	for item in ItemsInInv:
		#print("done")
		for point in item.ShapePoints:
			#if(InventoryDict[item.Position + point] == null):
			InventoryDict[item.Position + point] = item
			#print("YESs")
			#else:
				##print("NO NO NO") #Spit onto floor
				#print("IT WONT FIT")
				#break
			#CheckIfOK(InventoryDict)
	#print(InventoryDict)

func TryFitEverywhere(whatItem : InventoryItem)->Vector2i:
	var EmptySpaces : Array[Vector2i]
	for i in InventoryDict.keys():
		if(InventoryDict[i] == null):
			EmptySpaces.append(i)
	
	var SpaceFound : bool = false
	var FoundSpace
	for space in EmptySpaces:
		for point in whatItem.ShapePoints:
			SpaceFound = true
			if(!InventoryDict.has(space + point)):
				SpaceFound = false
				break
			if(InventoryDict[space + point] != null):
				SpaceFound = false
				break
		if(SpaceFound):
			FoundSpace = space
			break
	
	print(str(SpaceFound))
	if(SpaceFound):
		return FoundSpace
	else:
		return Vector2i(-1,-1)

#func CheckIfOK(thisLayout : Dictionary[Vector2i,InventoryItem]) -> bool:
	#for i in thisLayout:
		#if(thisLayout[i]==null):
			#thisLayout
			#return true
		#else:
			#return false
	#return false

func IsItemOK(_WhatItem:InventoryItem):
	for p in _WhatItem.ShapePoints:
		if(!InventoryDict.has(_WhatItem.Position + p)):
			return false
		if(InventoryDict[_WhatItem.Position+p] != null):
			return false
	return true

func TryAddNewItemToInventory(_NewItem : InventoryItem) -> bool:
	var foundPos = TryFitEverywhere(_NewItem)
	print(foundPos)
	if(foundPos!=Vector2i(-1,-1)):
		_NewItem.Position = foundPos
		ItemsInInv.append(_NewItem)
		UpdateInventoryDict()
		print("added to inventory")
		return true
	else:
		print("cant add to inventory")
		return false

func AddItemAtPosition(_WhatItem:InventoryItem,_WhatPosition : Vector2i):
	var tempItem = _WhatItem.duplicate()
	tempItem.Position = _WhatPosition
	if(IsItemOK(tempItem)):
		_WhatItem.Position = _WhatPosition
		ItemsInInv.append(_WhatItem)
		UpdateInventoryDict()
		return true
	else:
		return false
	
