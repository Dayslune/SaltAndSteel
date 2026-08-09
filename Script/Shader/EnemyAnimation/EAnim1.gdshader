shader_type canvas_item;

instance uniform float phase;
instance uniform float hit = 0.0;

uniform float VertexOffset = 10.0;
uniform float amplitude = 10.0;
instance uniform float speed = 4.0;

void vertex() {
    // Make the rendering area bigger
    VERTEX.xy += vec2(sign(VERTEX.xy)) * VertexOffset;

    // Bob up and down
    VERTEX.y += sin(TIME * speed + phase) * amplitude;
}

void fragment() {
    vec2 offset = VertexOffset / vec2(textureSize(TEXTURE, 0));

    // How much of the enlarged quad is actually the original texture
    vec2 scale = 1.0 + 2.0 * offset;

    // The original texture occupies the center of the enlarged quad
    vec2 uv = (UV - 0.5) * scale + 0.5;

    // Make the extra area transparent
    if (uv.x < 0.0 || uv.x > 1.0 ||
        uv.y < 0.0 || uv.y > 1.0) {
        discard;
    }

    COLOR = texture(TEXTURE, uv);

	COLOR.rgb = mix(COLOR.rgb, vec3(1.0 ,0.0 , 0.0), hit);
}