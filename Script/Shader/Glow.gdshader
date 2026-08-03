shader_type canvas_item;

uniform float glow_strength = 4.0;

void fragment() {
    COLOR *= glow_strength;
}