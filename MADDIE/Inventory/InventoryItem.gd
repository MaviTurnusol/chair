class_name InventoryItem
extends Resource

@export var ItemName : String
var Position : Vector2i
@export var ground_tex : Texture2D
@export var inventory_tex : Texture2D
@export var ShapePoints : Array[Vector2i]
@export var ground_scalemulti : float = 1
@export var inv_scalemulti : float = 1

var BaseShapePoints = null
var RotationState : Rotations = Rotations.ZERO

enum Rotations{
	ZERO = 0,
	NINETY = 90,
	ONEEIGHTY = 180,
	TWOSEVENTY = 270,
}

func RotateTo0():
	if(BaseShapePoints==null):
		BaseShapePoints = ShapePoints
	ShapePoints = BaseShapePoints
	RotationState = Rotations.ZERO

func RotateTo90():
	if(BaseShapePoints==null):
		BaseShapePoints = ShapePoints
	#x y
	#-y x
	
	var TranslatedPoints : Array[Vector2i]
	for p in BaseShapePoints:
		var newpoint = Vector2i(-p.y,p.x)
		TranslatedPoints.append(newpoint)
	ShapePoints = TranslatedPoints
	RotationState = Rotations.NINETY

func RotateTo180():
	if(BaseShapePoints==null):
		BaseShapePoints = ShapePoints
	
	#x y
	#-x,-y
	
	var TranslatedPoints : Array[Vector2i]
	for p in BaseShapePoints:
		var newpoint = Vector2i(-p.x,-p.y)
		TranslatedPoints.append(newpoint)
	ShapePoints = TranslatedPoints
	
	RotationState = Rotations.ONEEIGHTY

func RotateTo270():
	if(BaseShapePoints==null):
		BaseShapePoints = ShapePoints#
	
	#x y
	#y,-x
	
	var TranslatedPoints : Array[Vector2i]
	for p in BaseShapePoints:
		var newpoint = Vector2i(p.y,-p.x)
		TranslatedPoints.append(newpoint)
	ShapePoints = TranslatedPoints
	
	RotationState = Rotations.TWOSEVENTY

func RotateItem():
	match RotationState:
		Rotations.ZERO:
			RotateTo90()
		Rotations.NINETY:
			RotateTo180()
		Rotations.ONEEIGHTY:
			RotateTo270()
		Rotations.TWOSEVENTY:
			RotateTo0()
