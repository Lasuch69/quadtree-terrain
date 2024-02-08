shader_type spatial;

uniform sampler2D heightmap: hint_default_black, filter_linear, repeat_disable;
uniform sampler2D normal: hint_normal, filter_linear, repeat_disable;

uniform vec2 map_size = vec2(256.0, 256.0);
uniform float height_scale = 16.0;
uniform float normal_bias = 0.2;

varying vec2 tex_position;

vec3 unpack_normal(vec4 rgba) {
	vec3 n = rgba.xzy * 2.0 - vec3(1.0);
	n.z *= -1.0;
	return n;
}

void vertex() {
	tex_position = (VERTEX.xz + NODE_POSITION_WORLD.xz) / map_size + 0.5;
	
	float height = texture(heightmap, tex_position).x;
	VERTEX.y += height * height_scale;
	
	vec3 n = unpack_normal(texture(normal, tex_position));
	n.y *= normal_bias;
	NORMAL = n;
}

void fragment() {
	ALBEDO = vec3(1.0);
	
	vec3 n = unpack_normal(texture(normal, tex_position));
	n.y *= normal_bias;
	NORMAL = (VIEW_MATRIX * vec4(n, 0.0)).xyz;
}