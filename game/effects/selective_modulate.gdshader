shader_type canvas_item;

uniform vec4 color1 : source_color;
uniform vec4 color2 : source_color;
uniform vec4 color3 : source_color;

void fragment()
{
	vec4 original = texture(TEXTURE, UV);
	if(original != color1 && original != color2 && original != color3) COLOR = original;
}