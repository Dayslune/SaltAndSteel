shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float glow_strength : hint_range(0.0, 5.0) = 2.0;
uniform float glow_size : hint_range(0.0, 10.0) = 3.0;

void fragment() {
    vec4 text = texture(TEXTURE, UV);

    float glow = 0.0;

    for (float x = -glow_size; x <= glow_size; x += 1.0) {
        for (float y = -glow_size; y <= glow_size; y += 1.0) {
            vec2 offset = vec2(x, y) * TEXTURE_PIXEL_SIZE;

            glow += texture(TEXTURE, UV + offset).a;
        }
    }

    glow /= pow(glow_size * 2.0 + 1.0, 2.0);

    COLOR = text + glow_color * glow * glow_strength;
}