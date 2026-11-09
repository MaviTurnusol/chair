shader_type canvas_item;

uniform float FlashAmount = 0;

void fragment() {
	COLOR = COLOR + vec4(FlashAmount,FlashAmount,FlashAmount,FlashAmount);
}