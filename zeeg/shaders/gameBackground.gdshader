shader_type canvas_item;

uniform vec4 shade : source_color;

uniform float speed ;

void fragment() {
	vec2 scroll = vec2(TIME * speed) * vec2(-0.1,-0.2);
	vec4 tex = texture(TEXTURE,(SCREEN_UV * vec2(2.0,6.0)) + scroll);
	COLOR = tex * shade;
}