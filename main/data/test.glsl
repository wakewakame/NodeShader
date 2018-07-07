#version 150

precision highp float;
precision highp int;

uniform sampler2D backbuffer;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = step(length(mouse - position) * 100.0, 1.0);

	vec3 c = vec3( color );
	c +=  texture(backbuffer, position).rgb * 1.0;

	gl_FragColor = vec4( c, 1.0 );
}