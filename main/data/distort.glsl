#version 150

precision highp float;
precision highp int;

uniform sampler2D img;
uniform sampler2D normal_map;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float mult = 0.2;

void main(void){
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 normal = texture2D(normal_map, uv).xz;
	normal = (normal * 2.0) - 1.0;
	normal *= mult;
	uv += normal;
	gl_FragColor = texture2D(img, uv);
}