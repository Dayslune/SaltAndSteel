shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float shake : hint_range(0.0, 1.0) = 0.1;

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    
    if (rand(vec2(TIME, 0.0)) < shake) {
        uv.x += rand(vec2(TIME, uv.y)) * 0.01;
    }

    float r = texture(SCREEN_TEXTURE, uv + vec2(0.001, 0.0)).r;
    float g = texture(SCREEN_TEXTURE, uv).g;
    float b = texture(SCREEN_TEXTURE, uv - vec2(0.001, 0.0)).b;
    
    float scanline = sin(uv.y * 600.0) * 0.04;
    COLOR = vec4(r - scanline, g - scanline, b - scanline, 1.0);
}
