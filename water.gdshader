shader_type spatial;

uniform vec3 albedo : source_color;
uniform vec3 albedo2 : source_color;
uniform float metallic : hint_range(0.0, 1.0) = 0;
uniform float roughness : hint_range(0.0, 1.0) = 0.02;
uniform sampler2D wave;
uniform sampler2D wave_bump;
uniform sampler2D texture_normal;
uniform sampler2D texture_norm2;
uniform vec2 waveDirection = vec2(2.0,0.0);
uniform vec2 waveDirection2 = vec2(0.0,1.0);
uniform float time_scale : hint_range(0.0, 0.2, 0.005) = 0.06;
uniform float noise_scale = 10.0;
uniform float wave_time = 0.1;
uniform float height_scale = 1.52;

global uniform vec3 oceanPos;
uniform sampler2D depth_text : hint_depth_texture;
uniform sampler2D screen_text : hint_screen_texture;
uniform vec4 color_deep :source_color;
uniform vec4 color_shallow : source_color;
uniform float beers_law = 2.0;
uniform float depth_offset = -0.75;

uniform float edge_scale = 0.1;
uniform float near = 0.5;
uniform float far = 100.0;
uniform vec3 edge_color : source_color;

varying float height;
varying vec3 worldPos;

varying float vertex_distance;
varying float vertex_distance_clamped;
varying vec2 vertex_pos;


float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)),0.0,1.0)),amount);
}

float edge(float depth)
{
	depth = 2.0 * depth - 1.0;
	return near * far / (far + depth * (near - far));
}

float waveheight(vec2 offset, int mode)
{
	float h1 = 0.0;
	float h2 = 0.0;
	float hmix = 0.0;
	switch (mode)
	{
		case 0:
			h1 = texture (wave,(worldPos.xz + offset)/noise_scale + (TIME * waveDirection) * time_scale).r;
			return h1;
		case 1:
			h2 = texture (wave,(worldPos.xz + offset)/noise_scale + (TIME * waveDirection2) * time_scale).r;
			return h2;
		case 2:
			h1 = texture (wave,(worldPos.xz + offset)/noise_scale + (TIME * waveDirection) * time_scale).r;
			h2 = texture (wave,(worldPos.xz + offset)/noise_scale + (TIME * waveDirection2) * time_scale).r;
			hmix = mix(h1,h2,0.5);
			return hmix;
	}
}


void vertex() {
	
	worldPos = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
	
	vertex_distance = distance(worldPos,oceanPos);
	vertex_distance = clamp(vertex_distance,0.0,85.0);
	vertex_distance_clamped = vertex_distance/85.0;
	float height_mix = waveheight(vec2(0.0,0.0),2);
	
	float prev_height_x = waveheight(vec2(-0.3,0.0),2);
	float next_height_x = waveheight(vec2(0.3,0.0),2);
	float prev_height_y = waveheight(vec2(0.0,-0.3),2);
	float next_height_y = waveheight(vec2(0.0,0.3),2);
	
	//height = texture(wave,worldPos.xz/noise_scale + TIME*time_scale).r;
	VERTEX.y+= height_mix*height_scale * (1.0 - vertex_distance_clamped);
	float fraction_x = fract(round(UV.x* 1000.0)/10.0);
	float fraction_y = fract(round(UV.y* 1000.0)/10.0);
	
	if (fraction_x != 0.0)
	{
		if (fract(UV.y)== 0.0)
		{
			VERTEX.y = ((prev_height_x + next_height_x) * height_scale  * (1.0 - vertex_distance_clamped)) / 2.0;
		}
	}

	if (fraction_y != 0.0)
	{
		if (fract(UV.x)== 0.0)
		{
			VERTEX.y = ((prev_height_y + next_height_y) * height_scale * (1.0 - vertex_distance_clamped)) / 2.0;
		}
	}
			
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	float depth_texture = texture(depth_text, SCREEN_UV).r* 2.0 - 1.0;
	float depth = PROJECTION_MATRIX[3][2]/ (depth_texture + PROJECTION_MATRIX[2][2]);
	float depth_blend = exp((depth+VERTEX.z + depth_offset)* -beers_law);
	depth_blend = clamp(1.0 - depth_blend,0.0,1.0);
	float depth_blend_power = clamp(pow(depth_blend,2.5),0.0,1.0);
	
	vec3 screen_color = textureLod(screen_text, SCREEN_UV, depth_blend_power * 2.5).rgb;
	vec3 depth_color = mix(color_shallow.rgb,color_deep.rgb,depth_blend_power);
	vec3 color = mix(screen_color*depth_color, depth_color*0.25,depth_blend_power* 0.5);
	
	//getting edge
	float z_depth = edge(texture(depth_text, SCREEN_UV).x);
	float z_pos = edge(FRAGCOORD.z);
	float z_dif = z_depth - z_pos;
	
	vec2 time = (TIME * waveDirection)* time_scale;
	vec2 time2 = (TIME * waveDirection2)* time_scale;
	vec3 normal = texture(texture_normal,UV).rgb;
	//vec3 normal_blend = mix(texture(texture_norm2,worldPos.xz + time).rgb, texture(texture_norm2,worldPos.xz + time2).rgb, 0.5);
	vec3 normal_blend = mix(texture(texture_normal,worldPos.xz/10.0+time/10.0).rgb,texture(texture_norm2,worldPos.xz/10.0+time2/10.0).rgb,0.5);
	vec3 wave_normal_blend = mix(texture(wave_bump,worldPos.xz/noise_scale + time).xyz,texture(wave_bump,worldPos.xz / noise_scale + time2).xyz,0.3);
	
	
	float fresnel0 = fresnel(5.0, NORMAL, VIEW);
	vec3 surface_color = mix(albedo,albedo2, fresnel0);
	
	vec3 depth_color_adj = mix(edge_color, color, step(edge_scale,z_dif));
	
	ALBEDO = clamp(surface_color + depth_color_adj,vec3(0.0),vec3(1.0));//mix(surface_color,color,0.75);
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = mix(wave_normal_blend,normal_blend,0.5);
	SPECULAR = wave_normal_blend.r;
	// Called for every pixel the material is visible on.
}


//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
