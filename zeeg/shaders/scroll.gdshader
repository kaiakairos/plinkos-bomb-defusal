shader_type canvas_item;

uniform vec4 shade : source_color;
uniform float speed ;

void fragment() {
	vec2 scroll = vec2(TIME * speed) * vec2(-1.0,-0.4);
	vec4 tex = texture(TEXTURE,(SCREEN_UV * 20.0) + scroll);
	COLOR = tex * shade;
}
