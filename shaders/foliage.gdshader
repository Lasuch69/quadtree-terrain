shader_type particles;

uniform sampler2D heightmap: hint_default_black, filter_linear, repeat_disable;
uniform sampler2D normal: hint_normal, filter_linear, repeat_disable;

uniform int rows = 8;
uniform vec2 offset = vec2(1.0, 1.0);

uniform vec2 map_size = vec2(250.0, 250.0);
uniform float height_scale = 10.0;
uniform float normal_bias: hint_range(0.0, 1.0, 0.01) = 0.2;

vec3 unpack_normal(vec3 rgb) {
	vec3 n = rgb.xzy * 2.0 - vec3(1.0);
	n.z *= -1.0;
	return n;
}

mat3 rotation_from_angle(vec3 axis, float angle) {
	float c = cos(angle);
	float s = sin(angle);
	float t = 1.0 - c;
	vec3 a = axis;
	
	mat3 rotation_matrix = mat3(
		vec3(t * a.x * a.x + c, t * a.x * a.y - a.z * s, t * a.x * a.z + a.y * s),
		vec3(t * a.x * a.y + a.z * s, t * a.y * a.y + c, t * a.y * a.z - a.x * s),
		vec3(t * a.x * a.z - a.y *s, t * a.y * a.z + a.x * s, t * a.z * a.z + c)
	);
	
	return rotation_matrix;
}

mat3 align_to_normal(vec3 n) {
	vec3 up = vec3(0.0, 1.0, 0.0);
	vec3 axis = cross(up, n);
	float angle = acos(dot(up, n));
	
	return rotation_from_angle(axis, angle);
}

void start() {
	int index = int(INDEX);
	float x = float(index % rows);
	float y = float(index / rows);
	
	vec2 position = vec2(x, y);
	position -= float(rows - 1) / 2.0;
	position *= offset;
	
	TRANSFORM[3].xz = position + EMISSION_TRANSFORM[3].xz;
	
	vec2 tex_position = TRANSFORM[3].xz / map_size + 0.5;
	TRANSFORM[3].y = texture(heightmap, tex_position).r * height_scale;
	
	vec3 n = unpack_normal(texture(normal, tex_position).rgb);
	//n.y *= normal_bias;
	
	mat3 rotation = align_to_normal(n);
	
	TRANSFORM[0].xyz = rotation[0];
	TRANSFORM[1].xyz = rotation[1];
	TRANSFORM[2].xyz = rotation[2];
}
