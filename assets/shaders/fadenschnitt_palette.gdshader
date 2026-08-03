shader_type canvas_item;

uniform float palette_strength : hint_range(0.0, 1.0) = 0.68;

const vec3 PINE = vec3(0.063, 0.165, 0.141);
const vec3 MOSS = vec3(0.192, 0.353, 0.271);
const vec3 LICHEN = vec3(0.655, 0.769, 0.416);
const vec3 SILK = vec3(0.949, 0.910, 0.835);
const vec3 ORANGE = vec3(0.949, 0.549, 0.157);
const vec3 CORAL = vec3(0.890, 0.337, 0.290);

float color_distance(vec3 a, vec3 b) {
	vec3 delta = a - b;
	return dot(delta, delta);
}

vec3 nearest_palette_color(vec3 color) {
	vec3 best = PINE;
	float best_distance = color_distance(color, PINE);
	float distance_to_moss = color_distance(color, MOSS);
	if (distance_to_moss < best_distance) {
		best = MOSS;
		best_distance = distance_to_moss;
	}
	float distance_to_lichen = color_distance(color, LICHEN);
	if (distance_to_lichen < best_distance) {
		best = LICHEN;
		best_distance = distance_to_lichen;
	}
	float distance_to_silk = color_distance(color, SILK);
	if (distance_to_silk < best_distance) {
		best = SILK;
		best_distance = distance_to_silk;
	}
	float distance_to_orange = color_distance(color, ORANGE);
	if (distance_to_orange < best_distance) {
		best = ORANGE;
		best_distance = distance_to_orange;
	}
	if (color_distance(color, CORAL) < best_distance) {
		best = CORAL;
	}
	return best;
}

void fragment() {
	vec4 source = texture(TEXTURE, UV) * COLOR;
	vec3 palette_color = nearest_palette_color(source.rgb);
	COLOR = vec4(mix(source.rgb, palette_color, palette_strength), source.a);
}
