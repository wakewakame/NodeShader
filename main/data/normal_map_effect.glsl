#version 150

precision highp float;
precision highp int;

uniform sampler2D map;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 normal(vec2 v, float delta) {
  vec2 coefficient = vec2(
    texture(map, v + vec2(delta, 0.0)).x - texture(map, v - vec2(delta, 0.0)).x,
    texture(map, v + vec2(0.0, delta)).x - texture(map, v - vec2(0.0, delta)).x
  ) / delta;
  coefficient *= 0.3;
  vec3 req = vec3(
    -coefficient.x,
    -coefficient.y,
    1.0
  );
  req /= length(req);
  
  return req;
}

void main( void ) {
  vec2 uv = gl_FragCoord.xy / resolution;
  vec3 p = normal(uv, 0.01);
  p = (p + vec3(1.0)) * 0.5;
  gl_FragColor = vec4(p, 1.0);
}