#version 150

precision highp float;
precision highp int;

uniform float time; // time
uniform vec2 mouse; // mouse
uniform vec2 resolution; // resolution

const float pi = 3.1415926535;

void main(void){
	vec2 uv = gl_FragCoord.xy / resolution;
	float freq = mouse.x * 10.0;
	uv *= 2.0 * pi * freq;
	uv += time * 10.0;
	uv = vec2(sin(uv.x), cos(uv.y));
	uv *= 0.1;
	uv = (uv + vec2(1.0)) * 0.5;
	gl_FragColor = vec4(uv.x, 0.0, uv.y, 1.0);
}