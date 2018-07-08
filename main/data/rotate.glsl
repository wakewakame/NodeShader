#version 150

precision highp float;
precision highp int;

uniform sampler2D img;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float freq = 0.5;
const float pi = 3.14159265358979;

vec2 rotate(vec2 v, vec2 c, float r){
	v -= c;
	v = vec2(
		cos(r) * v.x - sin(r) * v.y,
		sin(r) * v.x + cos(r) * v.y
	);
	v += c;
	return v;
}

void main(void){
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	uv = rotate(uv, vec2(0.5), time * freq * 2.0 * pi);
	
	gl_FragColor = texture2D(img, uv);
}