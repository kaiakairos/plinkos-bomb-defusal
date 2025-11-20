shader_type canvas_item;

uniform sampler2D screenTexture :hint_screen_texture;

void fragment() {
	vec4 t = texture(screenTexture,SCREEN_UV);
	float average = (t.r + t.g + t.b) / 3.0;
	COLOR.rgb = vec3(average);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
