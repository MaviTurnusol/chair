extends ColorRect
@onready var animated_sprite_2d: AnimatedSprite2D = $MaskAnimations

@export var curAnim : String

func PlayMaskAnim(AnimName : String):
	curAnim = AnimName
	animated_sprite_2d.play(AnimName)

func SetScale(Percent : float):
	var sca = Percent/100
	sca = 1-sca
	self.material.set_shader_parameter("fill_amount",sca)

func _process(delta: float) -> void:
	#var tex = animated_sprite_2d.sprite_frames.get_frame_texture(animated_sprite_2d.animation,animated_sprite_2d.frame).get_image()
	
	var texture: Texture = animated_sprite_2d.sprite_frames.get_frame_texture(curAnim, animated_sprite_2d.frame)
	if(texture is AtlasTexture):
		pass
	else:
		pass
	if(texture):
		var new_texture: ImageTexture = ImageTexture.create_from_image(texture.get_image())
	#var material = self.get_surface_override_material(0)
		
		self.material.set_shader_parameter("use_different_texture",true)
		self.material.set_shader_parameter("mask_texture",new_texture)
	else:
		self.material.set_shader_parameter("use_different_texture",false)
	#print(tex)
	
