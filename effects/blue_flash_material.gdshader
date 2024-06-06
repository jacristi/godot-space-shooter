shader_type canvas_item;
render_mode unshaded;

void fragment() {
	// Output white for every pixel but kee the alpha
	vec4 input_color = texture(TEXTURE, UV);
	COLOR = vec4(.2, .2, 1, input_color.a);
}
